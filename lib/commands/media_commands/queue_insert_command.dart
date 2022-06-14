import 'dart:convert';

import 'package:cast/cast.dart';
import 'package:cast/commands/media_commands/enum/command_type.dart';

class CastQueueInsertCommand extends CastMediaCommand {
  CastQueueInsertCommand({
    required this.items,
    required this.mediaSessionId,
    this.customData,
    this.insertBefore,
  }) : super(type: MediaCommandType.QUEUE_INSERT);

  final List<CastQueueItem> items;
  final int mediaSessionId;
  final Map<String, dynamic>? customData;
  final int? insertBefore;

  @override
  Map<String, dynamic> toMap() {
    return {
      'mediaSessionId': mediaSessionId,
      'type': type.name,
      'items': items.map((x) => x.toMap()).toList(),
      'customData': customData,
      'insertBefore': insertBefore,
    };
  }

  factory CastQueueInsertCommand.fromMap(Map<String, dynamic> map) {
    return CastQueueInsertCommand(
      mediaSessionId: map['mediaSessionId']?.toInt() ?? 1,
      items: List<CastQueueItem>.from(
          map['items']?.map((x) => CastQueueItem.fromMap(x))),
      customData: Map<String, dynamic>.from(map['customData']),
      insertBefore: map['insertBefore']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CastQueueInsertCommand.fromJson(String source) =>
      CastQueueInsertCommand.fromMap(json.decode(source));
}
