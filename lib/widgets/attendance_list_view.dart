import 'package:flutter/material.dart';
import '../../../controller/attendance_controller.dart';
import 'attendance_card.dart';

class AttendanceListView extends StatelessWidget {
  final AttendanceController controller;

  const AttendanceListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.attendanceHistory.length,
      itemBuilder: (context, index) {
        final attendance = controller.attendanceHistory[index];
        return AttendanceCard(attendance: attendance);
      },
    );
  }
}
