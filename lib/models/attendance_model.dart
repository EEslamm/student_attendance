class AttendanceModel {
  final String email;
  final String qrData;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;
  final String deviceId;
  final String ipAddress;
  final String? courseId;

  AttendanceModel({
    required this.email,
    required this.qrData,
    required this.timestamp,
    this.latitude,
    this.longitude,
    required this.deviceId,
    required this.ipAddress,
    this.courseId,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      email: json['email'],
      qrData: json['qr_data'],
      timestamp: DateTime.parse(json['timestamp']),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      deviceId: json['device_id'],
      ipAddress: json['ip_address'],
      courseId: json['course_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'qr_data': qrData,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'device_id': deviceId,
      'ip_address': ipAddress,
      'course_id': courseId,
    };
  }
}