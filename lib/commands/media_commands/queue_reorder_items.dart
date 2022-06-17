import 'package:cast/cast.dart';
import 'package:cast/commands/media_commands/enum/command_type.dart';

///A request to reorder a list of media items in the queue.
class CastQueueReorderItems extends CastMediaCommand {
  CastQueueReorderItems({
    required this.itemIds,
    required super.mediaSessionId,
    this.insertBefore,
    this.customData,
  })  : assert(itemIds.isNotEmpty, 'Must not be null or empty.'),
        super(type: MediaCommandType.QUEUE_REORDER);

  ///Custom data for the receiver application.
  final Map<String, dynamic>? customData;

  ///ID of the item that will be located
  ///immediately after the reordered list.
  ///If null or not found, the reordered list will
  /// be appended at the end of the queue.
  /// This ID can not be one of the IDs
  ///  in the itemIds list.
  final int? insertBefore;

  /// The list of media item IDs to reorder, in the new order. Items not provided will keep their existing order (without the items being reordered). The provided list will be inserted at the position determined by insertBefore.

  /// For example:
  ///
  /// If insertBefore is not specified Existing queue: “A”,”D”,”G”,”H”,”B”,”E” itemIds: “D”,”H”,”B” New Order: “A”,”G”,”E”,“D”,”H”,”B”
  ///
  /// If insertBefore is “A” Existing queue: “A”,”D”,”G”,”H”,”B” itemIds: “D”,”H”,”B” New Order: “D”,”H”,”B”,“A”,”G”,”E”
  ///
  /// If insertBefore is “G” Existing queue: “A”,”D”,”G”,”H”,”B” itemIds: “D”,”H”,”B” New Order: “A”,“D”,”H”,”B”,”G”,”E”
  ///
  /// If any of the items does not exist it will be ignored. Must not be null or empty.
  final List<int> itemIds;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'itemIds': itemIds,
      'insertBefore': insertBefore,
      'mediaSessionId': mediaSessionId,
    };
  }
}
