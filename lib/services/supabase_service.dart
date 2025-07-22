import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/attendance_model.dart';

class SupabaseService extends GetxService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> saveAttendance(AttendanceModel attendance) async {
    try {
      await _client.from('attendance').insert(attendance.toJson());
    } catch (e) {
      throw Exception('Failed to save attendance: ${e.toString()}');
    }
  }

  Future<List<AttendanceModel>> getAttendanceHistory(String email) async {
    try {
      final response = await _client
          .from('attendance')
          .select()
          .eq('email', email)
          .order('timestamp', ascending: false);

      return (response as List)
          .map((json) => AttendanceModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load attendance history: ${e.toString()}');
    }
  }

  Future<bool> validateSessionId(String sessionId) async {
    try {
      final response = await _client
          .from('sessions')
          .select()
          .eq('session_id', sessionId)
          .eq('is_active', true);

      return (response as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}