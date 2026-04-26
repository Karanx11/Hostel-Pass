class PassModel {
  final String id;
  final String studentName;
  final String roomNumber;
  final String destination;
  final String reason;
  final DateTime outTime;
  final DateTime returnTime;
  String status;

  PassModel({
    required this.id,
    required this.studentName,
    required this.roomNumber,
    required this.destination,
    required this.reason,
    required this.outTime,
    required this.returnTime,
    required this.status,
  });
}
