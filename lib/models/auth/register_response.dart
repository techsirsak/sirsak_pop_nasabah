import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/address/address_model.dart';
import 'package:sirsak_pop_nasabah/models/user/nasabah_details_model.dart';
import 'package:sirsak_pop_nasabah/models/user/user_model.dart';

part 'register_response.freezed.dart';
part 'register_response.g.dart';

@freezed
abstract class RegisterResponse with _$RegisterResponse {
  const factory RegisterResponse({
    required UserModel user,
    required NasabahDetailsModel details,
    required AddressModel address,
  }) = _RegisterResponse;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}
