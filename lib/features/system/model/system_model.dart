import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_model.freezed.dart';
part 'system_model.g.dart';

@freezed
class SystemModel with _$SystemModel {
  const factory SystemModel({
    required String id,
    @JsonKey(name: 'menu_name') String? menuName,
    @JsonKey(name: 'system_name_en') required String systemNameEn,
    @JsonKey(name: 'system_name_ko') required String systemNameKo,
    @JsonKey(name: 'system_type') required String systemType,
    required String url,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _SystemModel;

  factory SystemModel.fromJson(Map<String, dynamic> json) => _$SystemModelFromJson(json);

  // 빈 시스템 모델 생성을 위한 팩토리 메서드
  factory SystemModel.empty() => const SystemModel(
        id: '',
        systemNameEn: '',
        systemNameKo: '',
        systemType: '',
        url: '',
      );
}
