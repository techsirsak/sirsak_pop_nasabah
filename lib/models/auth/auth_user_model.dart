import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user_model.freezed.dart';
part 'auth_user_model.g.dart';

@freezed
abstract class AuthUserModel with _$AuthUserModel {
  const factory AuthUserModel({
    required String id,
    required String aud,
    required String role,
    required String email,
    @JsonKey(name: 'email_confirmed_at') DateTime? emailConfirmedAt,
    String? phone,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'last_sign_in_at') DateTime? lastSignInAt,
    @JsonKey(name: 'app_metadata') AppMetadata? appMetadata,
    @JsonKey(name: 'user_metadata') UserMetadata? userMetadata,
    List<AuthIdentity>? identities,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'is_anonymous') @Default(false) bool isAnonymous,
  }) = _AuthUserModel;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);
}

@freezed
abstract class AppMetadata with _$AppMetadata {
  const factory AppMetadata({
    String? provider,
    List<String>? providers,
  }) = _AppMetadata;

  factory AppMetadata.fromJson(Map<String, dynamic> json) =>
      _$AppMetadataFromJson(json);
}

@freezed
abstract class UserMetadata with _$UserMetadata {
  const factory UserMetadata({
    String? email,
    @JsonKey(name: 'email_verified') @Default(false) bool emailVerified,
    @JsonKey(name: 'phone_verified') @Default(false) bool phoneVerified,
    String? sub,
  }) = _UserMetadata;

  factory UserMetadata.fromJson(Map<String, dynamic> json) =>
      _$UserMetadataFromJson(json);
}

@freezed
abstract class AuthIdentity with _$AuthIdentity {
  const factory AuthIdentity({
    @JsonKey(name: 'identity_id') String? identityId,
    String? id,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'identity_data') IdentityData? identityData,
    String? provider,
    @JsonKey(name: 'last_sign_in_at') DateTime? lastSignInAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    String? email,
  }) = _AuthIdentity;

  factory AuthIdentity.fromJson(Map<String, dynamic> json) =>
      _$AuthIdentityFromJson(json);
}

@freezed
abstract class IdentityData with _$IdentityData {
  const factory IdentityData({
    String? email,
    @JsonKey(name: 'email_verified') @Default(false) bool emailVerified,
    @JsonKey(name: 'phone_verified') @Default(false) bool phoneVerified,
    String? sub,
  }) = _IdentityData;

  factory IdentityData.fromJson(Map<String, dynamic> json) =>
      _$IdentityDataFromJson(json);
}
