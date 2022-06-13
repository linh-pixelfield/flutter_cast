import 'dart:convert';

import 'package:cast/cast.dart';

import 'enum/command_type.dart';

///Pauses playback of the current content.
///Triggers a STATUS event notification
/// to all sender applications.
class CastPauseCommand extends CastMediaCommand {
  CastPauseCommand({
    required this.mediaSessionId,
    this.customData,
    this.requestId,
  }) : super(type: MediaCommandType.PAUSE);

  /// mediaSessionId 	integer 	ID of the media session to be paused
  final int mediaSessionId;

  /// requestId 	integer 	ID of the request, to use to correlate request/response
  final int? requestId;

  /// customData 	object 	optional Application-specific blob of data defined by the sender application

  final Map<String, dynamic>? customData;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'mediaSessionId': mediaSessionId,
      'requestId': requestId,
      'customData': customData,
    };
  }

  factory CastPauseCommand.fromMap(Map<String, dynamic> map) {
    return CastPauseCommand(
      mediaSessionId: map['mediaSessionId']?.toInt() ?? 0,
      requestId: map['requestId']?.toInt(),
      customData: Map<String, dynamic>.from(map['customData']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CastPauseCommand.fromJson(String source) =>
      CastPauseCommand.fromMap(json.decode(source));
}
