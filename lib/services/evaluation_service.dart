import '../models/user_evaluation.dart';
import 'storage_service.dart';

class EvaluationService {
  final StorageService _storageService;

  EvaluationService(this._storageService);

  Future<void> saveEvaluation(UserEvaluation evaluation) async {
    await _storageService.saveEvaluation(evaluation);
  }

  Future<List<UserEvaluation>> getUserEvaluations(String userId) async {
    return await _storageService.getUserEvaluations(userId);
  }

  Future<List<UserEvaluation>> getPlaceEvaluations(String placeId) async {
    return await _storageService.getPlaceEvaluations(placeId);
  }

  Future<double?> getAverageRating(String placeId) async {
    final evaluations = await getPlaceEvaluations(placeId);
    if (evaluations.isEmpty) return null;
    
    final sum = evaluations.fold<double>(
      0.0,
      (sum, eval) => sum + eval.rating,
    );
    return sum / evaluations.length;
  }

  Future<bool> hasUserEvaluated(String userId, String placeId) async {
    final evaluations = await getUserEvaluations(userId);
    return evaluations.any((e) => e.placeId == placeId);
  }
}






