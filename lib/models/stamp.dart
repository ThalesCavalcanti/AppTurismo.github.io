import 'package:json_annotation/json_annotation.dart';

part 'stamp.g.dart';

@JsonSerializable()
class Stamp {
  final String id;
  final String name;
  final String description;
  final String icon; // Nome do ícone ou emoji
  final String category; // Mesma categoria do Place
  final String placeId; // ID do lugar associado
  final int rarity; // 1 = comum, 2 = raro, 3 = épico, 4 = lendário

  Stamp({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.placeId,
    this.rarity = 1,
  });

  factory Stamp.fromJson(Map<String, dynamic> json) => _$StampFromJson(json);
  Map<String, dynamic> toJson() => _$StampToJson(this);
}



