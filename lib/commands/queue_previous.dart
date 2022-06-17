import 'package:cast/cast.dart';
import 'package:cast/commands/media_commands/enum/command_type.dart';

class CastQueuePreviousCommand extends CastMediaCommand<List<CastMediaStatus>> {
  CastQueuePreviousCommand({
    required super.mediaSessionId,
  }) : super(type: MediaCommandType.QUEUE_PREV);

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'mediaSessionId': mediaSessionId,
    };
  }

  @override
  List<CastMediaStatus> decodeResponse(Map<String, dynamic> map) {
    return List.from(map['status'])
        .map((e) => CastMediaStatus.fromMap(e))
        .toList();
  }
}
