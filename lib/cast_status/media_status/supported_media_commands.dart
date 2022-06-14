import 'package:collection/collection.dart';

// 1  Pause
// 2  Seek
// 4  Stream volume
// 8  Stream mute
// 16  Skip forward
// 32  Skip backward
typedef SupportedMediaCommands = List<SupportedMediaCommand>;

enum SupportedMediaCommand {
  pause(1),
  seek(2),
  streamVolume(4),
  streamMute(8),
  skipForward(16),
  skipBackward(32);

  final int value;
  const SupportedMediaCommand(this.value);

  ///Combinations are described as summations; for example, Pause+Seek+StreamVolume+Mute == 15.
  static SupportedMediaCommands fromMap(int value) {
    final SupportedMediaCommands commands = [];
    for (final command in SupportedMediaCommand.values) {
      final sum = commands.map((e) => e.value).sum;
      if (sum == value) break;
      commands.add(command);
    }
    return commands;
  }
}
