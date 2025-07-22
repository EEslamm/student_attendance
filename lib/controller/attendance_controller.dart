import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../models/attendance_model.dart';
import '../services/supabase_service.dart';
import '../services/device_service.dart';
import 'auth_controller.dart';

class AttendanceController extends GetxController {
  final SupabaseService _supabaseService = Get.put(SupabaseService());
  final DeviceService _deviceService = Get.put(DeviceService());
  final AuthController _authController = Get.find<AuthController>();
  
  final RxList<AttendanceModel> attendanceHistory = <AttendanceModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<AttendanceModel?> lastAttendance = Rx<AttendanceModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadAttendanceHistory();
  }

  Future<void> markAttendance(String qrData) async {
    try {
      isLoading.value = true;
      
      // Get device information
      final deviceId = await _deviceService.getDeviceId();
      final ipAddress = await _deviceService.getIpAddress();
      
      // Get location
      Position? position;
      try {
        position = await _getCurrentPosition();
      } catch (e) {
        print('Location error: $e');
      }
      
      // Create attendance record
      final attendance = AttendanceModel(
        email: _authController.currentUser.value!.email,
        qrData: qrData,
        timestamp: DateTime.now(),
        latitude: position?.latitude,
        longitude: position?.longitude,
        deviceId: deviceId,
        ipAddress: ipAddress,
        courseId: _extractCourseId(qrData),
      );

      // Save to Supabase
      await _supabaseService.saveAttendance(attendance);
      
      // Update local data
      lastAttendance.value = attendance;
      attendanceHistory.insert(0, attendance);
      
      Get.toNamed('/attendance-success');
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark attendance: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Position?> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  String? _extractCourseId(String qrData) {
    // Extract course ID from QR data
    // This depends on your QR code format
    try {
      final parts = qrData.split('|');
      return parts.length > 1 ? parts[1] : null;
    } catch (e) {
      return null;
    }
  }

  Future<void> loadAttendanceHistory() async {
    try {
      isLoading.value = true;
      final history = await _supabaseService.getAttendanceHistory(
        _authController.currentUser.value!.email,
      );
      attendanceHistory.value = history;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load history: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}