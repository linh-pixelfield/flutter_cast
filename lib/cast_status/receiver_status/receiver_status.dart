import 'dart:convert';

import 'package:cast/common/cast_status_event.dart';
import 'package:cast/cast_status/receiver_status/models/receiver_status.dart';

class CastReceiverStatus {
  final int requestId;
  final ReceiverStatus status;
  CastReceiverStatus({
    required this.requestId,
    required this.status,
  });
  final CastStatusType type = CastStatusType.receiverStatus;

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'status': status.toMap(),
    };
  }

  factory CastReceiverStatus.fromMap(Map<String, dynamic> map) {
    return CastReceiverStatus(
      requestId: map['requestId']?.toInt() ?? 0,
      status: ReceiverStatus.fromMap(map['status']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CastReceiverStatus.fromJson(String source) =>
      CastReceiverStatus.fromMap(json.decode(source));
}
