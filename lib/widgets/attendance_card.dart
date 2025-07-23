import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/attendance_model.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceModel attendance;

  const AttendanceCard({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.qr_code, 'Qr Data: ${attendance.qrData ?? 'N/A'}'),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.phone_android, 'Device: ${_shortDeviceId()}'),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.language, 'IP: ${attendance.ipAddress}'),
            if (attendance.latitude != null && attendance.longitude != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_on,
                  'Location: ${attendance.latitude!.toStringAsFixed(4)}, ${attendance.longitude!.toStringAsFixed(4)}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
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
                  color: Colors.blue.shade700,
                ),
              ),
              Text(
                DateFormat('hh:mm a').format(attendance.timestamp),
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  String _shortDeviceId() {
    if (attendance.deviceId.length > 20) {
      return '${attendance.deviceId.substring(0, 20)}...';
    }
    return attendance.deviceId;
  }
}
