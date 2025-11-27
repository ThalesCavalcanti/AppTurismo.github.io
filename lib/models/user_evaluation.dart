import 'package:json_annotation/json_annotation.dart';

part 'user_evaluation.g.dart';

@JsonSerializable()
class UserEvaluation {
  final String id;
  final String placeId;
  final String userId;
  final double rating; // 1.0 a 5.0
  final String? comment;
  final DateTime createdAt;
  final Map<String, double>? categoryRatings; // acessibilidade, segurança, beleza, etc.

  UserEvaluation({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.categoryRatings,
  });

  factory UserEvaluation.fromJson(Map<String, dynamic> json) =>
      _$UserEvaluationFromJson(json);
  Map<String, dynamic> toJson() => _$UserEvaluationToJson(this);
}






