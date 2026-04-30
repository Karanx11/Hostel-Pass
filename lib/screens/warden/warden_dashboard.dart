import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hostel_pass/services/pass_services.dart';

class WardenDashboard extends StatefulWidget {
  const WardenDashboard({super.key});

  @override
  State<WardenDashboard> createState() => _WardenDashboardState();
}

class _WardenDashboardState extends State<WardenDashboard> {
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

  Widget buildEmptyState() {
    return const Center(
      child: Text("No pass requests yet", style: TextStyle(fontSize: 16)),
    );
  }

  Widget buildPassCard(Map<String, dynamic> pass) {
    final user = pass['users'];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user != null ? user['name'] : pass['student_email'],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (user != null) Text("Room: ${user['room_number'] ?? '-'}"),

                if (user != null) Text("Hostel: ${user['hostel_name'] ?? '-'}"),
              ],
            ),

            const SizedBox(height: 10),

            // Pass Details
            Text("Destination: ${pass['destination'] ?? ''}"),
            Text("Reason: ${pass['reason'] ?? ''}"),

            if (pass['out_time'] != null && pass['return_time'] != null) ...[
              const SizedBox(height: 6),

              Builder(
                builder: (context) {
                  final outTime = DateTime.parse(pass['out_time']);
                  final returnTime = DateTime.parse(pass['return_time']);

                  return Text(
                    "Time: ${DateFormat.jm().format(outTime)} - ${DateFormat.jm().format(returnTime)}",
                  );
                },
              ),
            ],

            const SizedBox(height: 12),

            // Status + Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(pass['status']),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    pass['status'].toString().toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (pass['status'] == "pending")
                  Row(
                    children: [
                      IconButton(
                        tooltip: "Approve",
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          await PassService().approvePass(pass['id']);
                          loadPasses();
                        },
                      ),

                      IconButton(
                        tooltip: "Reject",
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          await PassService().rejectPass(pass['id']);
                          loadPasses();
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Warden Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, "/warden-profile");
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          loadPasses();
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : passes.isEmpty
            ? buildEmptyState()
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: passes.length,
                itemBuilder: (context, index) {
                  final pass = passes[index];
                  return buildPassCard(pass);
                },
              ),
      ),
    );
  }
}
