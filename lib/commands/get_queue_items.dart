import 'dart:convert';

import 'package:cast/cast.dart';
import 'package:cast/commands/media_commands/enum/command_type.dart';

///Get items info request data.
class CastGetQueueItemsCommand extends CastMediaCommand<List<CastQueueItem>> {
  CastGetQueueItemsCommand({
    required this.itemIds,
    required super.mediaSessionId,
  }) : super(type: MediaCommandType.QUEUE_GET_ITEMS);

  ///List of item ids to be requested.
  final List<int> itemIds;
  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'itemIds': itemIds,
      'mediaSessionId': mediaSessionId,
    };
  }

  factory CastGetQueueItemsCommand.fromMap(Map<String, dynamic> map) {
    return CastGetQueueItemsCommand(
      itemIds: List<int>.from(map['itemIds']),
      mediaSessionId: map['mediaSessionId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CastGetQueueItemsCommand.fromJson(String source) =>
      CastGetQueueItemsCommand.fromMap(json.decode(source));

  @override
  List<CastQueueItem> decodeResponse(Map<String, dynamic> map) {
    return List<CastQueueItem>.from(
      map['items']?.map((x) => CastQueueItem.fromMap(x)),
    );
  }
}
