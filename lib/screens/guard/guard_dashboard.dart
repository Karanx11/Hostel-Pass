import 'package:flutter/material.dart';
import 'package:hostel_pass/screens/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuardDashboard extends StatelessWidget {
  const GuardDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guard Dashboard"),
        actions: [
          //  Profile
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, "/guard-profile");
            },
          ),

          // Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Supabase logout
              await Supabase.instance.client.auth.signOut();

              // Clear local role
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              //Navigate to login (direct)
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Title
            const Text(
              "Scan Student Pass",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            // Scan Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.qr_code_scanner, size: 28),
                label: const Text(
                  "Scan QR Code",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/scan");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
