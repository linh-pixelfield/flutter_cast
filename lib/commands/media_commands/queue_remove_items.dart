import 'dart:convert';

import 'package:cast/cast.dart';

import 'enum/command_type.dart';

///A request to remove a list of items from the queue.
///If the remaining queue is empty, the media
///session will be terminated.
class CastQueueRemoveItemsCommand extends CastMediaCommand {
  CastQueueRemoveItemsCommand({
    this.customData,
    required this.itemIds,
  })  : assert(itemIds.isNotEmpty, 'Must not be null or empty.'),
        super(type: MediaCommandType.QUEUE_REMOVE);

  ///Custom data for the
  /// receiver application.
  final Map<String, dynamic>? customData;

  ///The list of media item IDs to remove.
  /// If any of the items does not exist
  ///  it will be ignored. Duplicated item
  ///  IDs will also be ignored.
  ///  Must not be null or empty.
  final List<int> itemIds;
  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'customData': customData,
      'itemIds': itemIds,
    };
  }

  factory CastQueueRemoveItemsCommand.fromMap(Map<String, dynamic> map) {
    return CastQueueRemoveItemsCommand(
      customData: Map<String, dynamic>.from(map['customData']),
      itemIds: List<int>.from(map['itemIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CastQueueRemoveItemsCommand.fromJson(String source) =>
      CastQueueRemoveItemsCommand.fromMap(json.decode(source));
}
