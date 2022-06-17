import 'enum/command_type.dart';

class CastMediaCommand<T> {
  final MediaCommandType type;
  final int? mediaSessionId;

  CastMediaCommand({
    required this.type,
    this.mediaSessionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'mediaSessionId': mediaSessionId,
    };
  }

  T decodeResponse(Map<String, dynamic> map) {
    return map['response'];
  }
}
