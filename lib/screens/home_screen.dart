import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/attendance_controller.dart';
import '../../controller/auth_controller.dart';
import '../widgets/main_actions.dart';
import '../widgets/user_info_card.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.put(AttendanceController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Attendance'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'logout') {
                authController.logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,

        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UserInfoCard(authController),
                const SizedBox(height: 40),
                const Expanded(child: MainActions()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
