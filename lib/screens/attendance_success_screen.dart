import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/attendance_controller.dart';

class AttendanceSuccessScreen extends StatelessWidget {
  final AttendanceController attendanceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Marked'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 30),

                        Text(
                          'Attendance Marked Successfully!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 40),

                        // Attendance Details Card
                        Obx(() {
                          final attendance = attendanceController.lastAttendance.value;
                          if (attendance == null) return SizedBox.shrink();

                          return Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Attendance Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  _buildDetailRow(
                                    'Date & Time',
                                    DateFormat('MMM dd, yyyy - hh:mm a').format(attendance.timestamp),
                                    Icons.access_time,
                                  ),
                                  _buildDetailRow(
                                    'Email',
                                    attendance.email,
                                    Icons.email,
                                  ),
                                  _buildDetailRow(
                                    'Qr Data',
                                    attendance.qrData ?? 'N/A',
                                    Icons.qr_code,
                                  ),
                                  _buildDetailRow(
                                    'Device ID',
                                    attendance.deviceId.length > 15
                                        ? '${attendance.deviceId.substring(0, 15)}...'
                                        : attendance.deviceId,
                                    Icons.phone_android,
                                  ),
                                  _buildDetailRow(
                                    'IP Address',
                                    attendance.ipAddress,
                                    Icons.language,
                                  ),
                                  if (attendance.latitude != null && attendance.longitude != null)
                                    _buildDetailRow(
                                      'Location',
                                      '${attendance.latitude!.toStringAsFixed(4)}, ${attendance.longitude!.toStringAsFixed(4)}',
                                      Icons.location_on,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                
                // Action Buttons
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Get.offAllNamed('/home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Back to Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed('/attendance-history'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'View History',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey.shade600,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}