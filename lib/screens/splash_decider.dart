import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'student/student_dashboard.dart';
import 'warden/warden_dashboard.dart';
import 'guard/guard_dashboard.dart';

class SplashDecider extends StatefulWidget {
  const SplashDecider({super.key});

  @override
  State<SplashDecider> createState() => _SplashDeciderState();
}

class _SplashDeciderState extends State<SplashDecider> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    final userData = await UserService().getCurrentUserData();

    if (userData == null) {
      Navigator.pushReplacementNamed(context, "/");
      return;
    }

    final role = userData['role'];

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
    } else if (role == "guard") {
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
