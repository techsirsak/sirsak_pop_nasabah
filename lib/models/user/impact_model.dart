import 'package:freezed_annotation/freezed_annotation.dart';

part 'impact_model.freezed.dart';
part 'impact_model.g.dart';

@freezed
abstract class ImpactModel with _$ImpactModel {
  const factory ImpactModel({
    @Default(0) double collected,
    @Default(0) double recycled,
    @JsonKey(name: 'carbonFootprintReduced')
    @Default(0)
    double carbonFootprintReduced,
  }) = _ImpactModel;

  factory ImpactModel.fromJson(Map<String, dynamic> json) =>
      _$ImpactModelFromJson(json);
}
