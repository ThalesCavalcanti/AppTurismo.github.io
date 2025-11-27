import 'package:json_annotation/json_annotation.dart';

part 'check_in.g.dart';

@JsonSerializable()
class CheckIn {
  final String id;
  final String userId;
  final String placeId;
  final DateTime checkedInAt;
  final double? latitude;
  final double? longitude;
  final String? photo; // URL ou path da foto tirada no local

  CheckIn({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.checkedInAt,
    this.latitude,
    this.longitude,
    this.photo,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) =>
      _$CheckInFromJson(json);
  Map<String, dynamic> toJson() => _$CheckInToJson(this);
}



