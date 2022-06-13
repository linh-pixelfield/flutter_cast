import 'dart:convert';

import 'package:cast/cast.dart';

import 'enum/command_type.dart';

///Stops playback of the current content.
///Triggers a STATUS event notification to
/// all sender applications. After this
///  command the content will no longer
///  be loaded and the mediaSessionId is invalidated.
class CastStopCommand extends CastMediaCommand {
  CastStopCommand({
    required this.mediaSessionId,
    this.customData,
    this.requestId,
  }) : super(type: MediaCommandType.STOP);

  ///	ID of the media session for the content to be stopped
  final int mediaSessionId;

  ///ID of the request, to correlate request and response
  final int? requestId;

  ///optional Application-specific blob of data defined by the sender application
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
