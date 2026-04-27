import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hostel_pass/screens/splash_decider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:hostel_pass/screens/guard/guard_proffile_screen.dart';
import 'package:hostel_pass/screens/guard/scan_screen.dart';
import 'package:hostel_pass/screens/warden/warden_history_screen.dart';
import 'package:hostel_pass/screens/warden/warden_profile_screen.dart';

import 'screens/auth/login_screen.dart';

import 'screens/student/student_dashboard.dart';
import 'screens/warden/warden_dashboard.dart';
import 'screens/guard/guard_dashboard.dart';

import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hostel Pass',
      theme: AppTheme.darkTheme,

      home: session == null ? const LoginScreen() : const SplashDecider(),

      routes: {
        "/student": (context) => const StudentDashboard(),
        "/warden": (context) => const WardenDashboard(),
        "/guard": (context) => const GuardDashboard(),

        "/warden-profile": (context) => const WardenProfileScreen(),
        "/guard-profile": (context) => const GuardProfileScreen(),

        "/warden-history": (context) => const WardenHistoryScreen(),

        "/scan": (context) => const ScanScreen(),
      },
    );
  }
}
