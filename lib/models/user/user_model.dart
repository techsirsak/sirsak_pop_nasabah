import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/address/address_model.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/json_parsing_helper.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@Freezed(fromJson: false, toJson: true)
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
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
    @JsonKey(name: 'role_name') String? roleName,
    @JsonKey(name: 'business_name') String? businessName,
    String? name,
    @Default(0) int balance,
    @Default(0) int points,
    @JsonKey(name: 'bsu_id') String? bsuId,
    String? nik,
    @JsonKey(name: 'tanggal_lahir') String? tanggalLahir,
    @JsonKey(name: 'jenis_kelamin') String? jenisKelamin,
    @JsonKey(name: 'tempat_lahir') String? tempatLahir,
    @JsonKey(name: 'nasabah_bigint_id') int? nasabahBigintId,
    @JsonKey(name: 'bsu_bigint_id') int? bsuBigintId,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    // Embedded address (parsed from flat JSON)
    AddressModel? address,
  }) = _UserModel;

  /// Custom fromJson that extracts address fields into AddressModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Build AddressModel from flat address fields if address_id exists
    AddressModel? address;
    final addressId = json['address_id'] as String?;
    if (addressId != null) {
      address = AddressModel(
        id: addressId,
        provinsi: json['provinsi'] as String?,
        kota: json['kota'] as String?,
        kecamatan: json['kecamatan'] as String?,
        kelurahan: json['kelurahan'] as String?,
        rt: json['rt'] as String?,
        rw: json['rw'] as String?,
        alamatLengkap: json['alamat_lengkap'] as String?,
        mapUrl: json['map_url'] as String?,
        latitude: parseField<double?>(
          'latitude',
          json['latitude'],
          (v) => (v as num?)?.toDouble(),
        ),
        longitude: parseField<double?>(
          'longitude',
          json['longitude'],
          (v) => (v as num?)?.toDouble(),
        ),
      );
    }

    return UserModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      createdAt: parseField<DateTime>(
        'created_at',
        json['created_at'],
        (v) => DateTime.parse(v as String),
      ),
      email: json['email'] as String,
      roleId: json['role_id'] as String?,
      businessTypeId: json['business_type_id'] as String?,
      addressId: addressId,
      namaInstitusi: json['nama_institusi'] as String?,
      namaLengkap: json['nama_lengkap'] as String?,
      jabatan: json['jabatan'] as String?,
      noHp: json['no_hp'] as String?,
      userType: json['user_type'] as String?,
      roleName: json['role_name'] as String?,
      businessName: json['business_name'] as String?,
      name: json['name'] as String?,
      balance: parseField<int>(
        'balance',
        json['balance'],
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      points: parseField<int>(
        'points',
        json['points'],
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      bsuId: json['bsu_id'] as String?,
      nik: json['nik'] as String?,
      tanggalLahir: json['tanggal_lahir'] as String?,
      jenisKelamin: json['jenis_kelamin'] as String?,
      tempatLahir: json['tempat_lahir'] as String?,
      nasabahBigintId: parseField<int?>(
        'nasabah_bigint_id',
        json['nasabah_bigint_id'],
        (v) => (v as num?)?.toInt(),
      ),
      bsuBigintId: parseField<int?>(
        'bsu_bigint_id',
        json['bsu_bigint_id'],
        (v) => (v as num?)?.toInt(),
      ),
      updatedAt: parseField<DateTime?>(
        'updated_at',
        json['updated_at'],
        (v) => v != null ? DateTime.parse(v as String) : null,
      ),
      address: address,
    );
  }
}
