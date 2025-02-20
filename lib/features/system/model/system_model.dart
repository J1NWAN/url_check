import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_model.freezed.dart';
part 'system_model.g.dart';

@freezed
class SystemModel with _$SystemModel {
  const factory SystemModel({
    required String id,
    @JsonKey(name: 'system_name_en') String? systemNameEn,
    @JsonKey(name: 'system_name_ko') String? systemNameKo,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'created_at', fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime? updatedAt,
  }) = _SystemModel;

  factory SystemModel.fromJson(Map<String, dynamic> json) => _$SystemModelFromJson(json);

  // 빈 시스템 모델 생성을 위한 팩토리 메서드
  factory SystemModel.empty() => const SystemModel(
        id: '',
        systemNameEn: null,
        systemNameKo: null,
        url: null,
        createdAt: null,
        updatedAt: null,
      );
}

// Timestamp -> DateTime 변환
DateTime? _timestampFromJson(dynamic timestamp) {
  if (timestamp == null) return null;
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  }
  return null;
}

// DateTime -> Timestamp 변환
dynamic _timestampToJson(DateTime? date) {
  if (date == null) return null;
  return Timestamp.fromDate(date);
}
