import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_menu_model.freezed.dart';
part 'system_menu_model.g.dart';

@freezed
class SystemMenuModel with _$SystemMenuModel {
  const factory SystemMenuModel({
    @JsonKey(ignore: true) String? id,
    @JsonKey(name: 'menu_name') String? menuName,
    @JsonKey(name: 'system_code') String? systemCode,
    @JsonKey(name: 'path') String? path,
    @JsonKey(name: 'created_at', fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime? updatedAt,
  }) = _SystemMenuModel;

  factory SystemMenuModel.fromJson(Map<String, dynamic> json) => _$SystemMenuModelFromJson(json);

  // 빈 시스템 모델 생성을 위한 팩토리 메서드
  factory SystemMenuModel.empty() => const SystemMenuModel(
        menuName: null,
        systemCode: null,
        path: null,
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
