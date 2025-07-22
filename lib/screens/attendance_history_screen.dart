import'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/attendance_controller.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  final AttendanceController attendanceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance History'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => attendanceController.loadAttendanceHistory(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade50,
              Colors.orange.shade100,
            ],
          ),
        ),
        child: Obx(() {
          if (attendanceController.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade600),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Loading attendance history...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            );
          }

          if (attendanceController.attendanceHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 100,
                    color: Colors.orange.shade300,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No Attendance Records',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Start scanning QR codes to see your attendance history',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/qr-scanner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Scan QR Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: attendanceController.attendanceHistory.length,
            itemBuilder: (context, index) {
              final attendance = attendanceController.attendanceHistory[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('EEEE, MMM dd, yyyy').format(attendance.timestamp),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                                Text(
                                  DateFormat('hh:mm a').format(attendance.timestamp),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.green.shade300),
                            ),
                            child: Text(
                              'Present',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 12),
                      
                      Row(
                        children: [
                          Icon(Icons.book, size: 16, color: Colors.grey.shade600),
                          SizedBox(width: 8),
                          Text(
                            'Course: ${attendance.courseId ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Icon(Icons.phone_android, size: 16, color: Colors.grey.shade600),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Device: ${attendance.deviceId.length > 20 ? '${attendance.deviceId.substring(0, 20)}...' : attendance.deviceId}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Icon(Icons.language, size: 16, color: Colors.grey.shade600),
                          SizedBox(width: 8),
                          Text(
                            'IP: ${attendance.ipAddress}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      
                      if (attendance.latitude != null && attendance.longitude != null) ...[
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                            SizedBox(width: 8),
                            Text(
                              'Location: ${attendance.latitude!.toStringAsFixed(4)}, ${attendance.longitude!.toStringAsFixed(4)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}