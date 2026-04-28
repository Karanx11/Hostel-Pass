import 'package:supabase_flutter/supabase_flutter.dart';

class PassService {
  final supabase = Supabase.instance.client;

  /// Get current user safely
  User _requireUser() {
    final user = supabase.auth.currentUser;

    if (user == null || user.email == null) {
      throw Exception("User not logged in properly");
    }

    return user;
  }

  //  APPLY PASS
  Future<void> applyPass({
    required String destination,
    required String reason,
    required DateTime outTime,
    required DateTime returnTime,
  }) async {
    try {
      final user = _requireUser();

      await supabase.from('passes').insert({
        'student_email': user.email,
        'destination': destination,
        'reason': reason,
        'out_time': outTime.toIso8601String(),
        'return_time': returnTime.toIso8601String(),
        'status': 'pending',
      });
    } catch (e) {
      throw Exception("Failed to apply pass: $e");
    }
  }

  // GET STUDENT PASSES
  Future<List<Map<String, dynamic>>> getStudentPasses() async {
    try {
      final user = _requireUser();

      final data = await supabase
          .from('passes')
          .select('*, users!fk_user_email(name, room_number, hostel_name)')
          .eq('student_email', user.email!)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      throw Exception("Failed to fetch student passes: $e");
    }
  }

  // GET ALL PASSES (WARDEN)
  Future<List<Map<String, dynamic>>> getAllPasses() async {
    try {
      final data = await supabase
          .from('passes')
          .select('*, users!fk_user_email(name, room_number, hostel_name)')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      throw Exception("Failed to fetch all passes: $e");
    }
  }

  // ✅ APPROVE PASS
  Future<void> approvePass(String id) async {
    try {
      await supabase.from('passes').update({'status': 'approved'}).eq('id', id);
    } catch (e) {
      throw Exception("Failed to approve pass: $e");
    }
  }

  // ❌ REJECT PASS
  Future<void> rejectPass(String id) async {
    try {
      await supabase.from('passes').update({'status': 'rejected'}).eq('id', id);
    } catch (e) {
      throw Exception("Failed to reject pass: $e");
    }
  }

  // 🗑️ DELETE PASS
  Future<void> deletePass(String id) async {
    try {
      await supabase.from('passes').delete().eq('id', id);
    } catch (e) {
      throw Exception("Failed to delete pass: $e");
    }
  }

  // 🔍 GET PASS BY ID (VERY IMPORTANT for guard scanner)
  Future<Map<String, dynamic>?> getPassById(String id) async {
    try {
      final data = await supabase
          .from('passes')
          .select()
          .eq('id', id)
          .maybeSingle();

      return data;
    } catch (e) {
      throw Exception("Failed to fetch pass: $e");
    }
  }
}
