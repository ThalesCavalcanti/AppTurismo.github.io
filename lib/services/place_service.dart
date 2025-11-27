import '../models/place.dart';

class PlaceService {
  // Em produção, substitua por uma API real
  static const String baseUrl = 'https://api.example.com/places';
  
  // Dados mockados de lugares turísticos da Paraíba
  static final List<Place> _mockPlaces = [
    Place(
      id: '1',
      name: 'Praia de Tambaú',
      description: 'Uma das praias mais famosas de João Pessoa, com águas calmas e infraestrutura completa.',
      latitude: -7.1150,
      longitude: -34.8411,
      category: 'praia',
      images: [],
      averageRating: 4.5,
      totalRatings: 234,
      address: 'Tambaú, João Pessoa - PB',
      metadata: {
        'horario': '24h',
        'acessibilidade': true,
      },
    ),
    Place(
      id: '2',
      name: 'Centro Histórico de João Pessoa',
      description: 'Centro histórico com arquitetura colonial preservada e diversos pontos culturais.',
      latitude: -7.1195,
      longitude: -34.8806,
      category: 'histórico',
      images: [],
      averageRating: 4.7,
      totalRatings: 189,
      address: 'Centro, João Pessoa - PB',
    ),
    Place(
      id: '3',
      name: 'Areia Vermelha',
      description: 'Piscina natural formada na maré baixa, um dos principais pontos turísticos de Cabedelo.',
      latitude: -6.9611,
      longitude: -34.8339,
      category: 'natureza',
      images: [],
      averageRating: 4.8,
      totalRatings: 312,
      address: 'Cabedelo - PB',
    ),
    Place(
      id: '4',
      name: 'Museu de Arte Contemporânea',
      description: 'Museu com exposições de arte contemporânea brasileira.',
      latitude: -7.1200,
      longitude: -34.8800,
      category: 'cultural',
      images: [],
      averageRating: 4.3,
      totalRatings: 145,
      address: 'Centro, João Pessoa - PB',
    ),
    Place(
      id: '5',
      name: 'Praia do Coqueirinho',
      description: 'Praia paradisíaca com falésias e águas cristalinas em Conde.',
      latitude: -7.2667,
      longitude: -34.8333,
      category: 'praia',
      images: [],
      averageRating: 4.9,
      totalRatings: 278,
      address: 'Conde - PB',
    ),
  ];

  Future<List<Place>> getAllPlaces() async {
    // Em produção, fazer requisição HTTP real
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockPlaces;
  }

  Future<Place?> getPlaceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockPlaces.firstWhere((place) => place.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Place>> getPlacesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockPlaces.where((place) => place.category == category).toList();
  }

  Future<List<Place>> getPlacesNearby(
    double latitude,
    double longitude,
    double radiusKm,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Filtro simples por distância (em produção, usar cálculo de distância real)
    return _mockPlaces;
  }
}






