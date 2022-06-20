import 'dart:convert';

import 'package:cast/cast_status/receiver_status/models/application.dart';
import 'package:cast/common/volume.dart';

class ReceiverStatus {
  final List<CastApplication> applications;
  final bool isActiveInput;
  final CastMediaVolume volume;

  ReceiverStatus({
    required this.applications,
    required this.isActiveInput,
    required this.volume,
  });

  Map<String, dynamic> toMap() {
    return {
      'applications': applications.map((x) => x.toMap()).toList(),
      'isActiveInput': isActiveInput,
      'volume': volume.toMap(),
    };
  }

  factory ReceiverStatus.fromMap(Map<String, dynamic> map) {
    return ReceiverStatus(
      applications: List<CastApplication>.from(
          map['applications']?.map((x) => CastApplication.fromMap(x))),
      isActiveInput: map['isActiveInput'] ?? false,
      volume: CastMediaVolume.fromMap(map['volume']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceiverStatus.fromJson(String source) =>
      ReceiverStatus.fromMap(json.decode(source));
}
