import 'dart:convert';

import 'package:cast/cast.dart';

class CastLaunchCommand extends CastReceiverCommand {
  CastLaunchCommand({
    required this.appId,
  }) : super(type: ReceiverCommandType.LAUNCH);

  final String appId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'appId': appId,
    };
  }
}
