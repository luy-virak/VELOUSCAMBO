import 'package:cloud_firestore/cloud_firestore.dart';

class BikeModel {
  final String id;
  final String stationId;
  final String code;
  final String status; // 'available' | 'rented' | 'maintenance'
  final double condition; // 1.0 - 5.0

  const BikeModel({
    required this.id,
    required this.stationId,
    required this.code,
    required this.status,
    required this.condition,
  });

  bool get isAvailable => status == 'available';

  factory BikeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BikeModel(
      id: doc.id,
      stationId: data['stationId'] ?? '',
      code: data['code'] ?? '',
      status: data['status'] ?? 'available',
      condition: (data['condition'] as num?)?.toDouble() ?? 5.0,
    );
  }

  Map<String, dynamic> toMap() => {
        'stationId': stationId,
        'code': code,
        'status': status,
        'condition': condition,
      };
}
