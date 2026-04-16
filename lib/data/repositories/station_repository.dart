import '../../models/bike_model.dart';
import '../../models/station_model.dart';
import '../../services/firestore_service.dart';

class StationRepository {
  final FirestoreService _firestore;

  StationRepository() : _firestore = FirestoreService();

  Stream<List<StationModel>> watchStations() => _firestore.getStations();

  Stream<List<BikeModel>> watchBikesForStation(String stationId) =>
      _firestore.getBikesForStation(stationId);
}
