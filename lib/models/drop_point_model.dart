import 'package:freezed_annotation/freezed_annotation.dart';

part 'drop_point_model.freezed.dart';
part 'drop_point_model.g.dart';

/// Type of drop point
enum DropPointType {
  bankSampah,
  rvm,
}

@freezed
abstract class DropPointModel with _$DropPointModel {
  const factory DropPointModel({
    required String id,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required DropPointType type,
    required double rating,
    required int reviewCount,
    required String openingTime,
    required String closingTime,
    @Default(true) bool isOpen,
    String? imageUrl,
    String? phone,
    @Default([]) List<String> acceptedWasteTypes,
  }) = _DropPointModel;

  factory DropPointModel.fromJson(Map<String, dynamic> json) =>
      _$DropPointModelFromJson(json);
}

@freezed
abstract class UserLocation with _$UserLocation {
  const factory UserLocation({
    required double latitude,
    required double longitude,
    String? address,
  }) = _UserLocation;

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);
}
