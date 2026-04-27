import 'package:flutter/material.dart';
import 'package:hostel_pass/services/pass_services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String result = "Scan a QR code";
  bool isScanned = false;

  Future<void> validateQR(String passId) async {
    try {
      final pass = await PassService().getPassById(passId);

      if (pass == null) {
        setState(() {
          result = "❌ INVALID PASS (Not Found)";
        });
        return;
      }

      final status = pass['status'];
      final returnTime = DateTime.parse(pass['return_time']);
      final now = DateTime.now();

      if (status == "approved" && now.isBefore(returnTime)) {
        setState(() {
          result = "✅ VALID PASS";
        });
      } else if (status != "approved") {
        setState(() {
          result = "❌ NOT APPROVED";
        });
      } else {
        setState(() {
          result = "⏰ PASS EXPIRED";
        });
      }
    } catch (e) {
      setState(() {
        result = "❌ ERROR: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Pass")),

      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              onDetect: (capture) {
                if (isScanned) return;

                final barcode = capture.barcodes.first;
                final String? code = barcode.rawValue;

                if (code != null) {
                  isScanned = true;
                  validateQR(code);
                }
              },
            ),
          ),

          Expanded(
            flex: 1,
            child: Center(
              child: Text(result, style: const TextStyle(fontSize: 18)),
            ),
          ),

          // 🔁 Scan Again Button
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isScanned = false;
                  result = "Scan a QR code";
                });
              },
              child: const Text("Scan Again"),
            ),
          ),
        ],
      ),
    );
  }
}
