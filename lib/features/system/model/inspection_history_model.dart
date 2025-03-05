import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_history_model.freezed.dart';
part 'inspection_history_model.g.dart';

@freezed
class InspectionHistoryModel with _$InspectionHistoryModel {
  const factory InspectionHistoryModel({
    @JsonKey(ignore: true) String? id,
    @JsonKey(name: 'menu_name') String? menuName,
    @JsonKey(name: 'system_code') String? systemCode,
    @JsonKey(name: 'path') String? path,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'status_code') int? statusCode,
    @JsonKey(name: 'actual_status') String? actualStatus,
    @JsonKey(name: 'response_time') int? responseTime,
    @JsonKey(name: 'created_at', fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime? createdAt,
  }) = _InspectionHistoryModel;

  factory InspectionHistoryModel.fromJson(Map<String, dynamic> json) => _$InspectionHistoryModelFromJson(json);

// 빈 시스템 모델 생성을 위한 팩토리 메서드
  factory InspectionHistoryModel.empty() => const InspectionHistoryModel(
        menuName: null,
        systemCode: null,
        path: null,
        url: null,
        statusCode: null,
        actualStatus: null,
        responseTime: null,
        createdAt: null,
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
