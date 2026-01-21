import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
abstract class AddressModel with _$AddressModel {
  const factory AddressModel({
    required String id,
    String? provinsi,
    String? kota,
    String? kecamatan,
    String? kelurahan,
    String? rt,
    String? rw,
    @JsonKey(name: 'alamat_lengkap') String? alamatLengkap,
    @JsonKey(name: 'user_ref_id') String? userRefId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'map_url') String? mapUrl,
    double? latitude,
    double? longitude,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}
