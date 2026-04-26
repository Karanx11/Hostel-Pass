// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:hostel_pass/screens/auth/fake_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final result = FakeAuthService.login(email, password);

    if (result != null) {
      final role = result["role"];

      if (role == "student") {
        Navigator.pushReplacementNamed(context, "/student");
      } else if (role == "warden") {
        Navigator.pushReplacementNamed(context, "/warden");
      } else if (role == "guard") {
        Navigator.pushReplacementNamed(context, "/guard");
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid credentials")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // optional for better UI
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Hostel Pass",
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 25),

              // ✅ Button Updated
              ElevatedButton(
                onPressed: handleLogin,
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
