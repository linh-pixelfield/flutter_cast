import 'dart:convert';

import 'package:cast/cast.dart';
import 'package:cast/commands/media_commands/enum/command_type.dart';

///A request to update properties of the existing items in the media queue.
class CastQueueUpdateItemsCommand extends CastMediaCommand {
  CastQueueUpdateItemsCommand({
    required this.items,
    this.customData,
  }) : super(type: MediaCommandType.QUEUE_UPDATE);

  ///Custom data for the receiver application.
  final Map<String?, dynamic>? customData;

  ///List of queue items to be updated. No reordering will
  ///happen, the items will retain the existing order and
  /// will be fully replaced with the ones provided,
  ///  including the media information. The items not
  ///  provided in this list will remain unchanged.
  ///  The tracks information can not change once
  /// the item is loaded (if the item is the currentItem).
  ///  If any of the items does not exist it will be
  ///  ignored. Value must not be null.
  final List<CastQueueItem> items;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'customData': customData,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory CastQueueUpdateItemsCommand.fromMap(Map<String, dynamic> map) {
    return CastQueueUpdateItemsCommand(
      customData: Map<String?, dynamic>.from(map['customData']),
      items: List<CastQueueItem>.from(
          map['items']?.map((x) => CastQueueItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CastQueueUpdateItemsCommand.fromJson(String source) =>
      CastQueueUpdateItemsCommand.fromMap(json.decode(source));
}
