import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String result = "Scan a QR code";

  void validateQR(String data) {
    if (data.contains("ID:")) {
      setState(() {
        result = "✅ VALID PASS";
      });
    } else {
      setState(() {
        result = "❌ INVALID PASS";
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
                final List<Barcode> barcodes = capture.barcodes;

                for (final barcode in barcodes) {
                  final String? code = barcode.rawValue;

                  if (code != null) {
                    validateQR(code);
                    break; // stop after first scan
                  }
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
        ],
      ),
    );
  }
}
