import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/bike_model.dart';
import '../models/rental_model.dart';
import '../models/station_model.dart';
import '../services/firestore_service.dart';

class StationProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<StationModel> _stations = [];
  StationModel? _selectedStation;
  List<BikeModel> _selectedStationBikes = [];
  RentalModel? _activeRental;
  bool _isLoading = false;
  String? _error;

  StreamSubscription<List<StationModel>>? _stationsSubscription;
  StreamSubscription<List<BikeModel>>? _bikesSubscription;
  StreamSubscription<RentalModel?>? _rentalSubscription;

  List<StationModel> get stations => _stations;
  StationModel? get selectedStation => _selectedStation;
  List<BikeModel> get selectedStationBikes => _selectedStationBikes;
  RentalModel? get activeRental => _activeRental;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasActiveRental => _activeRental != null;

  void init(String userId) {
    _stationsSubscription?.cancel();
    _stationsSubscription =
        _firestoreService.getStations().listen((list) {
      _stations = list;
      notifyListeners();
    });

    _rentalSubscription?.cancel();
    _rentalSubscription =
        _firestoreService.getActiveRental(userId).listen((rental) {
      _activeRental = rental;
      notifyListeners();
    });
  }

  void selectStation(StationModel station) {
    _selectedStation = station;
    _bikesSubscription?.cancel();
    _bikesSubscription =
        _firestoreService.getBikesForStation(station.id).listen((bikes) {
      _selectedStationBikes = bikes;
      notifyListeners();
    });
    notifyListeners();
  }

  void clearSelectedStation() {
    _selectedStation = null;
    _selectedStationBikes = [];
    _bikesSubscription?.cancel();
    notifyListeners();
  }

  Future<RentalModel?> startRental({
    required String userId,
    required BikeModel bike,
    required StationModel station,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final rental = await _firestoreService.startRental(
        userId: userId,
        bike: bike,
        station: station,
      );
      _activeRental = rental;
      notifyListeners();
      return rental;
    } catch (e) {
      _error = 'Failed to start rental. Please try again.';
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> endRental() async {
    if (_activeRental == null) return false;
    _isLoading = true;
    notifyListeners();
    try {
      await _firestoreService.endRental(
        rentalId: _activeRental!.id,
        bikeId: _activeRental!.bikeId,
        stationId: _activeRental!.stationId,
        startTime: _activeRental!.startTime,
      );
      _activeRental = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to end rental. Please try again.';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _stationsSubscription?.cancel();
    _bikesSubscription?.cancel();
    _rentalSubscription?.cancel();
    super.dispose();
  }
}
