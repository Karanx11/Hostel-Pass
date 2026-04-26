import 'package:flutter/material.dart';

class GuardDashboard extends StatelessWidget {
  const GuardDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guard Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, "/guard-profile");
            },
          ),
        ],
      ),

      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text("Scan Pass"),
          onPressed: () {
            Navigator.pushNamed(context, "/scan");
          },
        ),
      ),
    );
  }
}
