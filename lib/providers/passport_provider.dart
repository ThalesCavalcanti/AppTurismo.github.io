import 'package:flutter/foundation.dart';
import '../models/stamp.dart';
import '../models/digital_passport.dart';
import '../services/passport_service.dart';

class PassportProvider with ChangeNotifier {
  final PassportService _passportService;
  DigitalPassport? _passport;
  List<Stamp> _allStamps = [];
  List<Stamp> _collectedStamps = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = false;
  String? _error;

  PassportProvider(this._passportService);

  DigitalPassport? get passport => _passport;
  List<Stamp> get allStamps => _allStamps;
  List<Stamp> get collectedStamps => _collectedStamps;
  List<String> get collectedStampIds => _passport?.collectedStampIds ?? [];
  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPassport(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Inicializar selos disponíveis
      await _passportService.initializeStamps();
      
      // Carregar passaporte
      _passport = await _passportService.getOrCreatePassport(userId);
      
      // Carregar todos os selos
      _allStamps = await _passportService.getAvailableStamps();
      
      // Carregar selos coletados
      _collectedStamps = await _passportService.getCollectedStamps(userId);
      
      // Carregar estatísticas
      _stats = await _passportService.getPassportStats(userId);
    } catch (e) {
      _error = 'Erro ao carregar passaporte: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkIn(String userId, String placeId,
      {double? latitude, double? longitude}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _passportService.checkIn(
        userId,
        placeId,
        latitude: latitude,
        longitude: longitude,
      );
      
      // Recarregar passaporte após check-in
      await loadPassport(userId);
      
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  bool hasVisitedPlace(String placeId) {
    return _passport?.hasVisitedPlace(placeId) ?? false;
  }

  bool hasStamp(String stampId) {
    return _passport?.hasStamp(stampId) ?? false;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}



