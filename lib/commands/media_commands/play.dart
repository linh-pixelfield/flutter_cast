import 'dart:convert';

import 'package:cast/cast.dart';

import 'enum/command_type.dart';

///Begins playback of the content that was loaded
///with the load call, playback is continued
///from the current time position.
class CastPlayCommand extends CastMediaCommand {
  CastPlayCommand({
    this.customData,
    required this.mediaSessionId,
    this.requestId,
  }) : super(type: MediaCommandType.PLAY);

  ///   	ID of the media session for the content to be played
  final int mediaSessionId;

  ///  	ID of the request, to correlate request and response
  final int? requestId;

  /// optional Application-specific blob of data defined by the sender application
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

  String toJson() => json.encode(toMap());
}
