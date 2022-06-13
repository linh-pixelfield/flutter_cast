import 'dart:convert';

import 'package:cast/cast.dart';
import 'package:cast/common/volume.dart';

///Sets the media stream volume. Used for
///fade-in/fade-out effects on the media stream.
/// (Note: receiver volume is changed using the
///  Web sender setVolume.) Stream volume must not
///  be used in conjunction with the volume
/// slider or volume buttons to control the
///  device volume. A change in stream
/// volume will not trigger any UI on the receiver.

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
