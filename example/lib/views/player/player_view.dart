import 'package:cast/common/media_metadata/movie_media_metadata.dart';
import 'package:example/views/player/player_controller.dart';
import 'package:example/views/player/widget/video_cast_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          body: Column(
            children: [
              VideoCastPlayer(controller: controller),
              Expanded(
                  child: ListView.builder(
                itemBuilder: _buildListTile,
                itemCount: controller.currentMediaStatus?.items?.length ?? 0,
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTile(BuildContext context, int index) {
    final controller = Get.find<PlayerController>();
    final item = controller.currentMediaStatus!.items![index];
    final metadata = item.media.metadata as CastMovieMediaMetadata;
    final image = (metadata.images ?? []).isEmpty ? null : metadata.images![0];
    return ListTile(
      leading: image != null ? Image.network(image.url.toString()) : null,
    );
  }
}
