import 'package:freezed_annotation/freezed_annotation.dart';

part 'setor_session_response.freezed.dart';
part 'setor_session_response.g.dart';

@freezed
abstract class SetorSessionResponse with _$SetorSessionResponse {
  const factory SetorSessionResponse({
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'collection_point_name') String? collectionPointName,
    @JsonKey(name: 'collection_point_type') String? collectionPointType,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    String? status,
  }) = _SetorSessionResponse;

  factory SetorSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$SetorSessionResponseFromJson(json);
}
