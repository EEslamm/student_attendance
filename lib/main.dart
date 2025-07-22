import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_attendance/screens/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:student_attendance/controller/auth_controller.dart';
import 'package:student_attendance/screens/home_screen.dart';
import 'package:student_attendance/screens/qr_scanner_screen.dart';
import 'package:student_attendance/screens/attendance_history_screen.dart';
import 'package:student_attendance/screens/attendance_success_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await Supabase.initialize(
    url: 'https://yjxeviiyycqtbmkfprpt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlqeGV2aWl5eWNxdGJta2ZwcnB0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxOTEwMDcsImV4cCI6MjA2ODc2NzAwN30.GsRq0jUDkJ7MFgAsCL1w8ehIasWGH3lliuglZLYXPG4',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Student Attendance',
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key, // ✅ أضف دي هنا

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/qr-scanner', page: () => QRScannerScreen()),
        GetPage(name: '/attendance-success', page: () => AttendanceSuccessScreen()),
        GetPage(name: '/attendance-history', page: () => AttendanceHistoryScreen()),
      ],
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return Obx(() {
      if (authController.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return authController.isLoggedIn.value ? HomeScreen() : LoginScreen();
    });
  }
}