import 'dart:math';
import '../models/place.dart';
import '../models/user_preferences.dart';
import 'evaluation_service.dart';

class MLRecommendationService {
  final EvaluationService _evaluationService;

  MLRecommendationService(this._evaluationService);

  /// Algoritmo de recomendação baseado em:
  /// - Preferências do usuário
  /// - Avaliações históricas
  /// - Popularidade do lugar
  /// - Distância do usuário
  Future<List<Place>> getRecommendations({
    required List<Place> places,
    required UserPreferences? preferences,
    required String userId,
    double? userLatitude,
    double? userLongitude,
  }) async {
    // Obter avaliações do usuário
    final userEvaluations = await _evaluationService.getUserEvaluations(userId);
    
    // Calcular scores para cada lugar
    final List<MapEntry<Place, double>> scoredPlaces = [];
    
    for (final place in places) {
      double score = 0.0;
      
      // 1. Score baseado em preferências de categoria (0-30 pontos)
      if (preferences != null) {
        if (preferences.preferredCategories.contains(place.category)) {
          score += 30.0;
        } else if (preferences.preferredCategories.isEmpty) {
          score += 15.0; // Se não há preferências, dar score neutro
        }
      } else {
        score += 15.0;
      }
      
      // 2. Score baseado em avaliação média (0-30 pontos)
      if (place.averageRating != null) {
        score += (place.averageRating! / 5.0) * 30.0;
      } else {
        score += 15.0; // Score neutro se não há avaliações
      }
      
      // 3. Score baseado em número de avaliações (0-20 pontos)
      if (place.totalRatings != null) {
        final popularityScore = min(place.totalRatings! / 100.0, 1.0);
        score += popularityScore * 20.0;
      }
      
      // 4. Score baseado em distância (0-20 pontos)
      if (userLatitude != null && userLongitude != null) {
        final distance = _calculateDistance(
          userLatitude,
          userLongitude,
          place.latitude,
          place.longitude,
        );
        // Lugares mais próximos recebem mais pontos
        final distanceScore = max(0.0, 1.0 - (distance / 50.0)); // 50km = 0 pontos
        score += distanceScore * 20.0;
      } else {
        score += 10.0; // Score neutro se não há localização
      }
      
      // 5. Penalizar lugares já avaliados pelo usuário (diversidade)
      final hasUserEvaluation = userEvaluations.any((e) => e.placeId == place.id);
      if (hasUserEvaluation) {
        score *= 0.7; // Reduzir score em 30%
      }
      
      scoredPlaces.add(MapEntry(place, score));
    }
    
    // Ordenar por score (maior primeiro)
    scoredPlaces.sort((a, b) => b.value.compareTo(a.value));
    
    // Retornar top N lugares
    return scoredPlaces.take(10).map((e) => e.key).toList();
  }

  /// Calcula distância em km entre duas coordenadas (fórmula de Haversine)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // km
    
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }
}






