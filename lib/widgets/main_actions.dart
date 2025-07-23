import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'action_button.dart';

class MainActions extends StatelessWidget {
  const MainActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ActionButton(
          color: Colors.green.shade600,
          height: 120,
          onTap: () => Get.toNamed('/qr-scanner'),
          icon: Icons.qr_code_scanner,
          title: 'Scan QR Code',
          subtitle: 'Mark your attendance',
        ),
        const SizedBox(height: 20),
        ActionButton(
          color: Colors.orange.shade600,
          height: 80,
          onTap: () => Get.toNamed('/attendance-history'),
          icon: Icons.history,
          title: 'Attendance History',
        ),
      ],
    );
  }
}
