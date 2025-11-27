import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_evaluation.dart';
import '../models/user_preferences.dart';

class StorageService {
  static const String _evaluationsKey = 'user_evaluations';
  static const String _preferencesKey = 'user_preferences';

  Future<void> saveEvaluation(UserEvaluation evaluation) async {
    final prefs = await SharedPreferences.getInstance();
    final evaluationsJson = prefs.getStringList(_evaluationsKey) ?? [];
    
    // Remover avaliação existente do mesmo usuário para o mesmo lugar
    evaluationsJson.removeWhere((json) {
      final eval = UserEvaluation.fromJson(jsonDecode(json));
      return eval.userId == evaluation.userId && eval.placeId == evaluation.placeId;
    });
    
    // Adicionar nova avaliação
    evaluationsJson.add(jsonEncode(evaluation.toJson()));
    await prefs.setStringList(_evaluationsKey, evaluationsJson);
  }

  Future<List<UserEvaluation>> getUserEvaluations(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final evaluationsJson = prefs.getStringList(_evaluationsKey) ?? [];
    
    return evaluationsJson
        .map((json) => UserEvaluation.fromJson(jsonDecode(json)))
        .where((eval) => eval.userId == userId)
        .toList();
  }

  Future<List<UserEvaluation>> getPlaceEvaluations(String placeId) async {
    final prefs = await SharedPreferences.getInstance();
    final evaluationsJson = prefs.getStringList(_evaluationsKey) ?? [];
    
    return evaluationsJson
        .map((json) => UserEvaluation.fromJson(jsonDecode(json)))
        .where((eval) => eval.placeId == placeId)
        .toList();
  }

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '${_preferencesKey}_${preferences.userId}',
      jsonEncode(preferences.toJson()),
    );
  }

  Future<UserPreferences?> getUserPreferences(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('${_preferencesKey}_$userId');
    if (json == null) return null;
    return UserPreferences.fromJson(jsonDecode(json));
  }
}

