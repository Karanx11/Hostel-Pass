import 'package:flutter/material.dart';
import 'package:hostel_pass/services/pass_services.dart';

class ApplyPassScreen extends StatefulWidget {
  const ApplyPassScreen({super.key});

  @override
  State<ApplyPassScreen> createState() => _ApplyPassScreenState();
}

class _ApplyPassScreenState extends State<ApplyPassScreen> {
  final destinationController = TextEditingController();
  final reasonController = TextEditingController();

  TimeOfDay? outTime;
  TimeOfDay? returnTime;

  bool isLoading = false;

  Future<void> pickTime(bool isOutTime) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        if (isOutTime) {
          outTime = time;
        } else {
          returnTime = time;
        }
      });
    }
  }

  void submitForm() async {
    if (destinationController.text.isEmpty ||
        reasonController.text.isEmpty ||
        outTime == null ||
        returnTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Fill all fields")));
      return;
    }

    final now = DateTime.now();

    final outDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      outTime!.hour,
      outTime!.minute,
    );

    final returnDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      returnTime!.hour,
      returnTime!.minute,
    );

    try {
      setState(() => isLoading = true);

      await PassService().applyPass(
        destination: destinationController.text,
        reason: reasonController.text,
        outTime: outDateTime,
        returnTime: returnDateTime,
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Apply Pass")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: destinationController,
              decoration: const InputDecoration(hintText: "Destination"),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: "Reason"),
            ),
            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => pickTime(true),
                    child: Text(
                      outTime == null ? "Out Time" : outTime!.format(context),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => pickTime(false),
                    child: Text(
                      returnTime == null
                          ? "Return Time"
                          : returnTime!.format(context),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: isLoading ? null : submitForm,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
