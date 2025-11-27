import 'package:flutter/foundation.dart';
import '../models/place.dart';
import '../services/place_service.dart';
import '../services/ml_recommendation_service.dart';
import '../services/evaluation_service.dart';
import '../services/storage_service.dart';

class PlaceProvider with ChangeNotifier {
  final PlaceService _placeService;
  final MLRecommendationService _mlService;
  final EvaluationService _evaluationService;
  final StorageService _storageService;

  List<Place> _allPlaces = [];
  List<Place> _recommendedPlaces = [];
  Place? _selectedPlace;
  bool _isLoading = false;
  String? _error;
  final String _currentUserId = 'user_1'; // Em produção, obter do sistema de autenticação

  PlaceProvider(
    this._placeService,
    this._mlService,
    this._evaluationService,
    this._storageService,
  );

  List<Place> get allPlaces => _allPlaces;
  List<Place> get recommendedPlaces => _recommendedPlaces;
  Place? get selectedPlace => _selectedPlace;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPlaces() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allPlaces = await _placeService.getAllPlaces();
      await _loadRecommendations();
    } catch (e) {
      _error = 'Erro ao carregar lugares: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadRecommendations() async {
    try {
      final preferences = await _storageService.getUserPreferences(_currentUserId);
      _recommendedPlaces = await _mlService.getRecommendations(
        places: _allPlaces,
        preferences: preferences,
        userId: _currentUserId,
        // Em produção, obter localização do usuário
        userLatitude: null,
        userLongitude: null,
      );
    } catch (e) {
      debugPrint('Erro ao carregar recomendações: $e');
    }
  }

  Future<void> selectPlace(String placeId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedPlace = await _placeService.getPlaceById(placeId);
      if (_selectedPlace != null) {
        // Atualizar rating médio
        final avgRating = await _evaluationService.getAverageRating(placeId);
        if (avgRating != null) {
          _selectedPlace = Place(
            id: _selectedPlace!.id,
            name: _selectedPlace!.name,
            description: _selectedPlace!.description,
            latitude: _selectedPlace!.latitude,
            longitude: _selectedPlace!.longitude,
            category: _selectedPlace!.category,
            images: _selectedPlace!.images,
            averageRating: avgRating,
            totalRatings: _selectedPlace!.totalRatings,
            address: _selectedPlace!.address,
            metadata: _selectedPlace!.metadata,
          );
        }
      }
    } catch (e) {
      _error = 'Erro ao carregar lugar: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshRecommendations() async {
    await _loadRecommendations();
    notifyListeners();
  }
}




