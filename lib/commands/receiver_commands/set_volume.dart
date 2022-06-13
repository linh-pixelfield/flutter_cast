import 'dart:convert';

import 'package:cast/cast.dart';
import 'package:cast/cast_events/cast_media_status_message_event/volume.dart';
import 'package:cast/commands/receiver_commands/enums/receiver_command_type.dart';
import 'package:cast/commands/receiver_commands/receiver_command.dart';
export 'package:cast/cast_events/cast_media_status_message_event/volume.dart';

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
