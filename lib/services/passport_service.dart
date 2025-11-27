import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stamp.dart';
import '../models/check_in.dart';
import '../models/digital_passport.dart';

class PassportService {
  static const String _passportKey = 'digital_passport';
  static const String _stampsKey = 'available_stamps';

  // Criar ou obter passaporte do usuário
  Future<DigitalPassport> getOrCreatePassport(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final passportJson = prefs.getString('${_passportKey}_$userId');

    if (passportJson != null) {
      return DigitalPassport.fromJson(jsonDecode(passportJson));
    }

    // Criar novo passaporte
    final passport = DigitalPassport(
      userId: userId,
      createdAt: DateTime.now(),
    );
    await savePassport(passport);
    return passport;
  }

  Future<void> savePassport(DigitalPassport passport) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '${_passportKey}_${passport.userId}',
      jsonEncode(passport.toJson()),
    );
  }

  // Fazer check-in em um lugar
  Future<CheckIn> checkIn(String userId, String placeId,
      {double? latitude, double? longitude, String? photo}) async {
    final passport = await getOrCreatePassport(userId);
    
    // Verificar se já fez check-in neste lugar hoje
    final today = DateTime.now();
    final hasCheckedInToday = passport.checkIns.any((checkIn) {
      return checkIn.placeId == placeId &&
          checkIn.checkedInAt.year == today.year &&
          checkIn.checkedInAt.month == today.month &&
          checkIn.checkedInAt.day == today.day;
    });

    if (hasCheckedInToday) {
      throw Exception('Você já fez check-in neste lugar hoje!');
    }

    // Criar check-in
    final checkIn = CheckIn(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      placeId: placeId,
      checkedInAt: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
      photo: photo,
    );

    // Obter selo para este lugar
    final stamps = await getAvailableStamps();
    final placeStamp = stamps.firstWhere(
      (stamp) => stamp.placeId == placeId,
      orElse: () => _createDefaultStamp(placeId),
    );

    // Atualizar passaporte
    final updatedCheckIns = [...passport.checkIns, checkIn];
    final hasStamp = passport.collectedStampIds.contains(placeStamp.id);
    final updatedStampIds = hasStamp
        ? passport.collectedStampIds
        : [...passport.collectedStampIds, placeStamp.id];

    // Contar lugares únicos visitados
    final uniquePlaces = updatedCheckIns
        .map((ci) => ci.placeId)
        .toSet()
        .length;

    final updatedPassport = DigitalPassport(
      userId: userId,
      collectedStampIds: updatedStampIds,
      checkIns: updatedCheckIns,
      totalPlacesVisited: uniquePlaces,
      totalStamps: updatedStampIds.length,
      createdAt: passport.createdAt,
      lastUpdated: DateTime.now(),
    );

    await savePassport(updatedPassport);
    return checkIn;
  }

  // Obter selos disponíveis
  Future<List<Stamp>> getAvailableStamps() async {
    final prefs = await SharedPreferences.getInstance();
    final stampsJson = prefs.getStringList(_stampsKey) ?? [];

    if (stampsJson.isEmpty) {
      // Criar selos padrão baseados nos lugares
      return _createDefaultStamps();
    }

    return stampsJson
        .map((json) => Stamp.fromJson(jsonDecode(json)))
        .toList();
  }

  // Obter selos coletados pelo usuário
  Future<List<Stamp>> getCollectedStamps(String userId) async {
    final passport = await getOrCreatePassport(userId);
    final allStamps = await getAvailableStamps();

    return allStamps
        .where((stamp) => passport.collectedStampIds.contains(stamp.id))
        .toList();
  }

  // Criar selo padrão para um lugar
  Stamp _createDefaultStamp(String placeId) {
    // Este será substituído por selos reais baseados no lugar
    return Stamp(
      id: 'stamp_$placeId',
      name: 'Sel de Local',
      description: 'Sel obtido ao visitar este local',
      icon: '📍',
      category: 'geral',
      placeId: placeId,
      rarity: 1,
    );
  }

  // Criar selos padrão baseados nos lugares conhecidos
  List<Stamp> _createDefaultStamps() {
    return [
      Stamp(
        id: 'stamp_praia_tambau',
        name: 'Sel Praia de Tambaú',
        description: 'Desbloqueado ao visitar a Praia de Tambaú',
        icon: '🏖️',
        category: 'praia',
        placeId: '1',
        rarity: 1,
      ),
      Stamp(
        id: 'stamp_centro_historico',
        name: 'Sel Centro Histórico',
        description: 'Desbloqueado ao visitar o Centro Histórico',
        icon: '🏛️',
        category: 'histórico',
        placeId: '2',
        rarity: 2,
      ),
      Stamp(
        id: 'stamp_areia_vermelha',
        name: 'Sel Areia Vermelha',
        description: 'Desbloqueado ao visitar Areia Vermelha',
        icon: '🏝️',
        category: 'natureza',
        placeId: '3',
        rarity: 2,
      ),
      Stamp(
        id: 'stamp_museu',
        name: 'Sel Museu de Arte',
        description: 'Desbloqueado ao visitar o Museu de Arte Contemporânea',
        icon: '🎨',
        category: 'cultural',
        placeId: '4',
        rarity: 1,
      ),
      Stamp(
        id: 'stamp_coqueirinho',
        name: 'Sel Praia do Coqueirinho',
        description: 'Desbloqueado ao visitar a Praia do Coqueirinho',
        icon: '🌴',
        category: 'praia',
        placeId: '5',
        rarity: 3,
      ),
    ];
  }

  // Inicializar selos disponíveis
  Future<void> initializeStamps() async {
    final prefs = await SharedPreferences.getInstance();
    final existingStamps = prefs.getStringList(_stampsKey);

    if (existingStamps == null || existingStamps.isEmpty) {
      final defaultStamps = _createDefaultStamps();
      final stampsJson = defaultStamps
          .map((stamp) => jsonEncode(stamp.toJson()))
          .toList();
      await prefs.setStringList(_stampsKey, stampsJson);
    }
  }

  // Obter estatísticas do passaporte
  Future<Map<String, dynamic>> getPassportStats(String userId) async {
    final passport = await getOrCreatePassport(userId);
    final allStamps = await getAvailableStamps();
    
    final statsByCategory = <String, int>{};
    for (final stampId in passport.collectedStampIds) {
      final stamp = allStamps.firstWhere(
        (s) => s.id == stampId,
        orElse: () => _createDefaultStamp('unknown'),
      );
      statsByCategory[stamp.category] =
          (statsByCategory[stamp.category] ?? 0) + 1;
    }

    return {
      'totalStamps': passport.totalStamps,
      'totalPlaces': passport.totalPlacesVisited,
      'totalAvailable': allStamps.length,
      'completionPercentage':
          allStamps.isEmpty ? 0 : (passport.totalStamps / allStamps.length * 100).round(),
      'statsByCategory': statsByCategory,
    };
  }
}

