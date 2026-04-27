import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userData = await supabase
            .from('users')
            .select()
            .eq('email', email)
            .single();

        return userData;
      }
    } catch (e) {
      print("Login error: $e");
    }
    return null;
  }
}
