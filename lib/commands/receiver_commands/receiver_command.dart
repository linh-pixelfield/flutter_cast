import 'package:cast/commands/receiver_commands/enums/receiver_command_type.dart';

class CastReceiverCommand {
  final ReceiverCommandType type;
  CastReceiverCommand({
    required this.type,
  });

  Map<String, dynamic> toMap() => {};
}
