import 'dart:convert';
import 'command.dart';
import 'enum/command_type.dart';

///Retrieves the media status.
class CastGetStatusCommand extends CastMediaCommand {
  CastGetStatusCommand({
    this.mediaSessionId,
    this.requestId,
    this.customData,
  }) : super(type: MediaCommandType.GET_STATUS);

  ///optional Media session ID of the media
  /// for which the media status should
  /// be returned. If none is provided,
  ///  then the status for all media
  ///  session IDs will be provided.
  final int? mediaSessionId;

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
