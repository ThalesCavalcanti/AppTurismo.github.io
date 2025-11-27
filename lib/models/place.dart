import 'package:json_annotation/json_annotation.dart';

part 'place.g.dart';

@JsonSerializable()
class Place {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String category; // praia, histórico, cultural, natureza, etc.
  final List<String> images;
  final double? averageRating;
  final int? totalRatings;
  final String? address;
  final Map<String, dynamic>? metadata; // horários, preços, etc.

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.category,
    this.images = const [],
    this.averageRating,
    this.totalRatings,
    this.address,
    this.metadata,
  });

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}






