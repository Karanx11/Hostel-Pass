import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DigitalPassScreen extends StatelessWidget {
  final Map<String, dynamic> pass;

  const DigitalPassScreen({super.key, required this.pass});

  @override
  Widget build(BuildContext context) {
    // 🧠 Convert timestamps
    final DateTime outTime = DateTime.parse(pass['out_time']);
    final DateTime returnTime = DateTime.parse(pass['return_time']);

    final now = DateTime.now();

    final isExpired = now.isAfter(returnTime);
    final isApproved = pass['status'] == "approved";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Digital Pass")),

      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "HOSTEL PASS",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 10),

              // 🔴 STATUS
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isExpired
                      ? Colors.red
                      : (isApproved ? Colors.green : Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isExpired
                      ? "TIME EXCEEDED"
                      : (isApproved ? "VERIFIED" : "PENDING"),
                  style: const TextStyle(color: Colors.black),
                ),
              ),

              const SizedBox(height: 20),

              // 👤 Student Info
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/student.png"),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pass['student_email'] ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 📍 Details
              Text(
                "Destination: ${pass['destination'] ?? ''}",
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                "Reason: ${pass['reason'] ?? ''}",
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 15),

              // TIME INFO
              Text(
                "Out: ${DateFormat.jm().format(outTime)}",
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                "Return: ${DateFormat.jm().format(returnTime)}",
                style: const TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 20),

              // 🔳 QR (ONLY if valid)
              if (!isExpired && isApproved)
                QrImageView(
                  data: pass['id'], // 🔥 IMPORTANT: only pass ID
                  size: 180,
                  backgroundColor: Colors.white,
                ),

              // ❌ Expired
              if (isExpired)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "PASS EXPIRED ❌",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              const SizedBox(height: 10),

              Text(
                "Pass ID: ${pass['id']}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
