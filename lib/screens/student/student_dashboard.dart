import 'package:flutter/material.dart';
import 'package:hostel_pass/pass/digital_pass_screen.dart';
import 'package:hostel_pass/screens/student/apply_pass_screen.dart';
import 'package:hostel_pass/screens/student/profile_screen.dart';
import 'package:hostel_pass/services/pass_services.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  List<Map<String, dynamic>> passes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPasses();
  }

  void loadPasses() async {
    final data = await PassService().getStudentPasses();

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
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ApplyPassScreen()),
          );

          if (result == true) {
            loadPasses();
          }
        },
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : passes.isEmpty
          ? const Center(child: Text("No passes yet"))
          : ListView.builder(
              itemCount: passes.length,
              itemBuilder: (context, index) {
                final pass = passes[index];

                return Dismissible(
                  key: Key(pass['id']),
                  onDismissed: (_) async {
                    await PassService().deletePass(pass['id']);
                    loadPasses();
                  },
                  background: Container(color: Colors.red),

                  child: GestureDetector(
                    onTap: () {
                      if (pass['status'] == "approved") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DigitalPassScreen(pass: pass),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Pass not approved yet 🚫"),
                          ),
                        );
                      }
                    },

                    child: Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(pass['destination'] ?? ''),
                        subtitle: Text(pass['reason'] ?? ''),
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
                    ),
                  ),
                );
              },
            ),
    );
  }
}
