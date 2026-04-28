import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/user_service.dart';
import '../auth/login_screen.dart';

class WardenProfileScreen extends StatefulWidget {
  const WardenProfileScreen({super.key});

  @override
  State<WardenProfileScreen> createState() => _WardenProfileScreenState();
}

class _WardenProfileScreenState extends State<WardenProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    final data = await UserService().getCurrentUserData();

    if (!mounted) return;

    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  Future<void> handleLogout() async {
    // 🔐 Supabase logout
    await Supabase.instance.client.auth.signOut();

    // 🧹 Clear local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 🚀 Go to login screen
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userData == null) {
      return const Scaffold(body: Center(child: Text("User not found")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Warden Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/warden.webp"),
            ),

            const SizedBox(height: 20),

            Text(userData!["name"] ?? "", style: const TextStyle(fontSize: 20)),

            const SizedBox(height: 20),

            buildTile("Email", userData!["email"] ?? ""),
            buildTile("Role", userData!["role"] ?? ""),
            buildTile("Hostel", userData!["hostel_name"] ?? "-"),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: handleLogout,
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Text(value)],
      ),
    );
  }
}
