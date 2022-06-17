import 'dart:convert';

import 'package:cast/cast.dart';

class CastSetVolumeCommand extends CastReceiverCommand {
  CastSetVolumeCommand({
    required this.volume,
  }) : super(type: ReceiverCommandType.SET_VOLUME);

  ///Stream volume
  final CastMediaVolume volume;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'volume': volume.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}
