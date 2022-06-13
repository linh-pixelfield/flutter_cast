import 'enum/command_type.dart';

class CastMediaCommand {
  final MediaCommandType type;

  CastMediaCommand({
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
    };
  }
}
