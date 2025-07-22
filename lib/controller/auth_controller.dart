import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final GetStorage _storage = GetStorage();
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;

  final GlobalKey<NavigatorState> aadNavigatorKey = GlobalKey<NavigatorState>();
  late AadOAuth _oauth;

  @override
  void onInit() {
    super.onInit();
    _initializeOAuth();
    _checkLoginSession(); // سيتم تعريف هذه الدالة الآن
  }

  void _checkLoginSession() {
    try {
      final userJson = _storage.read('user');
      final accessToken = _storage.read('access_token');

      if (userJson != null && accessToken != null) {
        currentUser.value = UserModel.fromJson(userJson);
        isLoggedIn.value = true;
      } else {
        isLoggedIn.value = false;
        _clearStoredData();
      }
    } catch (e) {
      print('Error checking login session: $e');
      isLoggedIn.value = false;
      _clearStoredData();
    }
  }

  void _initializeOAuth() {
    final config = Config(
      tenant: 'ae362704-0450-46f2-ab02-2b0a1df6406d',
      clientId: 'f63c230a-230c-40ec-9b07-d065c5776f90',
      scope: 'openid profile offline_access',
      redirectUri: 'https://login.microsoftonline.com/common/oauth2/nativeclient',
      navigatorKey: Get.key, // ✅ استخدم Get.key
    );
    _oauth = AadOAuth(config);
  }

  Future<void> login() async {
    try {
      isLoading.value = true;
      await _oauth.login();
      final accessToken = await _oauth.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Failed to get access token');
      }

      final idToken = await _oauth.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to get ID token');
      }

      final userClaims = _parseJwtToken(idToken);
      if (userClaims.isEmpty) {
        throw Exception('Failed to parse user claims');
      }

      final user = UserModel.fromJson(userClaims);
      currentUser.value = user;
      isLoggedIn.value = true;

      await _storage.write('user', user.toJson());
      await _storage.write('access_token', accessToken);

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _parseJwtToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) throw Exception('Invalid token format');

      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));

      return json.decode(decoded) as Map<String, dynamic>;
    } catch (e) {
      print('Token parsing error: $e');
      return {};
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _oauth.logout();
      await _clearStoredData();
      currentUser.value = null;
      isLoggedIn.value = false;
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _clearStoredData() async {
    await _storage.remove('user');
    await _storage.remove('access_token');
  }

  @override
  void onClose() {
    _oauth.logout();
    super.onClose();
  }
}