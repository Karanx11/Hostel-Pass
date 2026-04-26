import '../models/pass_model.dart';
import 'dart:math';

class PassService {
  static final List<PassModel> _passes = [];

  static List<PassModel> getPasses() {
    return _passes;
  }

  static void addPass(
    String destination,
    String reason,
    DateTime outTime,
    DateTime returnTime,
  ) {
    _passes.add(
      PassModel(
        id: Random().nextInt(10000).toString(),
        studentName: "Karan Sharma",
        roomNumber: "101",
        destination: destination,
        reason: reason,
        outTime: outTime,
        returnTime: returnTime,
        status: "pending",
      ),
    );
  }

  static void deletePass(String id) {
    _passes.removeWhere((pass) => pass.id == id);
  }

  static void approvePass(String id) {
    final pass = _passes.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception("Pass not found"),
    );
    pass.status = "approved";
  }

  static void rejectPass(String id) {
    final pass = _passes.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception("Pass not found"),
    );
    pass.status = "rejected";
  }
}
