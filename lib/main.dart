import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:hostel_pass/screens/guard/guard_proffile_screen.dart';
import 'package:hostel_pass/screens/guard/scan_screen.dart';
import 'package:hostel_pass/screens/warden/warden_history_screen.dart';
import 'package:hostel_pass/screens/warden/warden_profile_screen.dart';

import 'screens/auth/login_screen.dart';
import 'theme/app_theme.dart';

import 'screens/student/student_dashboard.dart';
import 'screens/warden/warden_dashboard.dart';
import 'screens/guard/guard_dashboard.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  Prevent screenshots & screen recording
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  // Load environment variables
  await dotenv.load(fileName: ".env");

  //Supabase
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hostel Pass',
      theme: AppTheme.darkTheme,

      initialRoute: "/",

      routes: {
        "/": (context) => const LoginScreen(),
        "/student": (context) => const StudentDashboard(),
        "/warden": (context) => const WardenDashboard(),
        "/guard": (context) => const GuardDashboard(),

        //  Profiles
        "/warden-profile": (context) => const WardenProfileScreen(),
        "/guard-profile": (context) => const GuardProfileScreen(),

        // History
        "/warden-history": (context) => const WardenHistoryScreen(),

        // Scanner
        "/scan": (context) => const ScanScreen(),
      },
    );
  }
}
