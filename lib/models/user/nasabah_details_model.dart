import 'package:freezed_annotation/freezed_annotation.dart';

part 'nasabah_details_model.freezed.dart';
part 'nasabah_details_model.g.dart';

@freezed
abstract class NasabahDetailsModel with _$NasabahDetailsModel {
  const factory NasabahDetailsModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    String? name,
    @Default(0) int balance,
    @JsonKey(name: 'bsu_id') String? bsuId,
    @JsonKey(name: 'no_hp') String? noHp,
    @JsonKey(name: 'address_id') String? addressId,
    String? nik,
    @JsonKey(name: 'tanggal_lahir') String? tanggalLahir,
    @JsonKey(name: 'jenis_kelamin') String? jenisKelamin,
    @JsonKey(name: 'tempat_lahir') String? tempatLahir,
    @JsonKey(name: 'nasabah_bigint_id') int? nasabahBigintId,
    @JsonKey(name: 'bsu_bigint_id') int? bsuBigintId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _NasabahDetailsModel;

  factory NasabahDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$NasabahDetailsModelFromJson(json);
}
