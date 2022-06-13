import 'package:example/views/player/player_controller.dart';
import 'package:example/views/player/widget/video_cast_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayerController>(
      init: PlayerController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Player',
            ),
            actions: [
              if (controller.activeSession)
                IconButton(
                    onPressed: controller.openGallery,
                    icon: const Icon(Icons.play_circle)),
              IconButton(
                icon: controller.activeSession
                    ? const Icon(Icons.cast_connected)
                    : const Icon(Icons.cast),
                onPressed: controller.activeSession
                    ? controller.closeSession
                    : controller.openCastDevices,
              ),
            ],
          ),
          body: VideoCastPlayer(controller: controller),
        );
      },
    );
  }
}
