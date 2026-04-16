import 'package:cloud_firestore/cloud_firestore.dart';

class StationModel {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final int totalDocks;
  final int availableBikes;

  const StationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.totalDocks,
    required this.availableBikes,
  });

  factory StationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StationModel(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
      totalDocks: (data['totalDocks'] as num?)?.toInt() ?? 0,
      availableBikes: (data['availableBikes'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'address': address,
        'lat': lat,
        'lng': lng,
        'totalDocks': totalDocks,
        'availableBikes': availableBikes,
      };

  StationModel copyWith({int? availableBikes}) => StationModel(
        id: id,
        name: name,
        address: address,
        lat: lat,
        lng: lng,
        totalDocks: totalDocks,
        availableBikes: availableBikes ?? this.availableBikes,
      );
}
