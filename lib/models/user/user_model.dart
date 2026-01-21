import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required String email,
    @JsonKey(name: 'role_id') String? roleId,
    @JsonKey(name: 'business_type_id') String? businessTypeId,
    @JsonKey(name: 'address_id') String? addressId,
    @JsonKey(name: 'nama_institusi') String? namaInstitusi,
    @JsonKey(name: 'nama_lengkap') String? namaLengkap,
    String? jabatan,
    @JsonKey(name: 'no_hp') String? noHp,
    @JsonKey(name: 'user_type') String? userType,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
