import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/attendance_controller.dart';
import '../widgets/attendance_empty_view.dart';
import '../widgets/attendance_list_view.dart';
import '../widgets/attendance_loading_view.dart';


class AttendanceHistoryScreen extends StatelessWidget {
  final AttendanceController attendanceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => attendanceController.loadAttendanceHistory(),
          ),
        ],
      ),
      body: Container(
        decoration: _background(),
        child: Obx(() {
          if (attendanceController.isLoading.value) {
            return const AttendanceLoadingView();
          }

          if (attendanceController.attendanceHistory.isEmpty) {
            return const AttendanceEmptyView();
          }

          return AttendanceListView(controller: attendanceController);
        }),
      ),
    );
  }

  BoxDecoration _background() {
    return BoxDecoration(
      color: Colors.white,
    );
  }
}
