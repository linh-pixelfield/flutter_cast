import 'dart:convert';

import 'package:cast/cast_status/receiver_status/models/name_spaces.dart';

class CastApplication {
  final String appId;
  final String displayName;
  final List<CastNameSpaces> namespaces;
  final String sessionId;
  final String statusText;
  final String transportId;
  CastApplication({
    required this.appId,
    required this.displayName,
    required this.namespaces,
    required this.sessionId,
    required this.statusText,
    required this.transportId,
  });

  Map<String, dynamic> toMap() {
    return {
      'appId': appId,
      'displayName': displayName,
      'namespaces': namespaces.map((x) => x.toMap()).toList(),
      'sessionId': sessionId,
      'statusText': statusText,
      'transportId': transportId,
    };
  }

  factory CastApplication.fromMap(Map<String, dynamic> map) {
    return CastApplication(
      appId: map['appId'] ?? '',
      displayName: map['displayName'] ?? '',
      namespaces: List<CastNameSpaces>.from(
          map['namespaces']?.map((x) => CastNameSpaces.fromMap(x))),
      sessionId: map['sessionId'] ?? '',
      statusText: map['statusText'] ?? '',
      transportId: map['transportId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CastApplication.fromJson(String source) =>
      CastApplication.fromMap(json.decode(source));
}
