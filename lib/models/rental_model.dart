import 'package:cloud_firestore/cloud_firestore.dart';

class RentalModel {
  final String id;
  final String userId;
  final String bikeId;
  final String bikeCode;
  final String stationId;
  final String stationName;
  final DateTime startTime;
  final DateTime? endTime;
  final int? durationMinutes;
  final String status; // 'active' | 'completed'

  const RentalModel({
    required this.id,
    required this.userId,
    required this.bikeId,
    required this.bikeCode,
    required this.stationId,
    required this.stationName,
    required this.startTime,
    this.endTime,
    this.durationMinutes,
    required this.status,
  });

  bool get isActive => status == 'active';

  Duration get elapsed => DateTime.now().difference(startTime);

  String get elapsedFormatted {
    final d = elapsed;
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) return '${h}h ${m.toString().padLeft(2, '0')}m';
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  factory RentalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RentalModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      bikeId: data['bikeId'] ?? '',
      bikeCode: data['bikeCode'] ?? '',
      stationId: data['stationId'] ?? '',
      stationName: data['stationName'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: data['endTime'] != null
          ? (data['endTime'] as Timestamp).toDate()
          : null,
      durationMinutes: data['durationMinutes'],
      status: data['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'bikeId': bikeId,
        'bikeCode': bikeCode,
        'stationId': stationId,
        'stationName': stationName,
        'startTime': Timestamp.fromDate(startTime),
        'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
        'durationMinutes': durationMinutes,
        'status': status,
      };
}
