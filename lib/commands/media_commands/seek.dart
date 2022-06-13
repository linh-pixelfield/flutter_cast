import 'dart:convert';

import 'package:cast/cast.dart';

import 'enum/command_type.dart';
import 'enum/resume_state.dart';

///Sets the current position in the stream.
///Triggers a STATUS event notification to
///all sender applications. If the position
/// provided is outside the range of valid
///  positions for the current content,
///  then the player should pick a valid
///  position as close to the requested
///  position as possible.
class CastSeekCommand extends CastMediaCommand {
  CastSeekCommand({
    this.requestId,
    required this.mediaSessionId,
    required this.currentTime,
    this.resumeState,
    this.customData,
  }) : super(type: MediaCommandType.SEEK);

  ///ID of the media session where the position of the stream is set
  final int mediaSessionId;

  ///	ID of the request, to correlate request and response
  final int? requestId;

  /// optional If this is not set, playback status will not change; the following values apply:
  ///    ``` PLAYBACK_START```  Forces media to start
  ///     ```PLAYBACK_PAUSE```  Forces media to pause
  final CastResumeState? resumeState;

  ///optional Seconds since beginning of content.
  /// If the content is live content, and position
  ///  is not specifed, the stream will start at
  ///  the live position
  final Duration? currentTime;

  ///optional Application-specific blob of data defined by the sender application
  final Map<String, dynamic>? customData;
  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'mediaSessionId': mediaSessionId,
      'requestId': requestId,
      'resumeState': resumeState?.name,
      'currentTime': currentTime?.inSeconds,
      'customData': customData,
    };
  }

  String toJson() => json.encode(toMap());
}
