import 'package:flutter/material.dart';
import 'package:hostel_pass/services/pass_services.dart';

class WardenHistoryScreen extends StatefulWidget {
  const WardenHistoryScreen({super.key});

  @override
  State<WardenHistoryScreen> createState() => _WardenHistoryScreenState();
}

class _WardenHistoryScreenState extends State<WardenHistoryScreen> {
  List<Map<String, dynamic>> passes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPasses();
  }

  void loadPasses() async {
    final data = await PassService().getAllPasses();

    setState(() {
      passes = data;
      isLoading = false;
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Requests History")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : passes.isEmpty
          ? const Center(child: Text("No history yet"))
          : ListView.builder(
              itemCount: passes.length,
              itemBuilder: (context, index) {
                final pass = passes[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(pass['student_email'] ?? ''),
                    subtitle: Text(pass['destination'] ?? ''),
                    trailing: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: getStatusColor(pass['status']),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        pass['status'].toUpperCase(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
