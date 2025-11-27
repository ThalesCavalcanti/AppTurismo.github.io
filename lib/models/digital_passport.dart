import 'package:json_annotation/json_annotation.dart';
import 'check_in.dart';

part 'digital_passport.g.dart';

@JsonSerializable()
class DigitalPassport {
  final String userId;
  final List<String> collectedStampIds;
  final List<CheckIn> checkIns;
  final int totalPlacesVisited;
  final int totalStamps;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  DigitalPassport({
    required this.userId,
    this.collectedStampIds = const [],
    this.checkIns = const [],
    this.totalPlacesVisited = 0,
    this.totalStamps = 0,
    required this.createdAt,
    this.lastUpdated,
  });

  factory DigitalPassport.fromJson(Map<String, dynamic> json) =>
      _$DigitalPassportFromJson(json);
  Map<String, dynamic> toJson() => _$DigitalPassportToJson(this);

  bool hasStamp(String stampId) {
    return collectedStampIds.contains(stampId);
  }

  bool hasVisitedPlace(String placeId) {
    return checkIns.any((checkIn) => checkIn.placeId == placeId);
  }
}

