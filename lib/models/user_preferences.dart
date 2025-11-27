import 'package:json_annotation/json_annotation.dart';

part 'user_preferences.g.dart';

@JsonSerializable()
class UserPreferences {
  final String userId;
  final List<String> preferredCategories;
  final double? budgetRange; // faixa de orçamento
  final int? preferredDuration; // duração preferida em horas
  final bool prefersAccessibility;
  final Map<String, double> categoryWeights; // pesos para ML

  UserPreferences({
    required this.userId,
    this.preferredCategories = const [],
    this.budgetRange,
    this.preferredDuration,
    this.prefersAccessibility = false,
    this.categoryWeights = const {},
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);
}






