import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'student/student_dashboard.dart';
import 'warden/warden_dashboard.dart';
import 'guard/guard_dashboard.dart';
import 'package:hostel_pass/screens/auth/login_screen.dart';

class SplashDecider extends StatefulWidget {
  const SplashDecider({super.key});

  @override
  State<SplashDecider> createState() => _SplashDeciderState();
}

class _SplashDeciderState extends State<SplashDecider> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  void redirect() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString("role");

    await Future.delayed(const Duration(milliseconds: 300)); // small buffer

    if (!mounted) return;

    if (role == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    if (role == "student") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentDashboard()),
      );
    } else if (role == "warden") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WardenDashboard()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GuardDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
