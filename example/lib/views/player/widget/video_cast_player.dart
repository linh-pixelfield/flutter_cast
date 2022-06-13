import 'package:duration/duration.dart';
import 'package:example/views/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:iso_duration_parser/iso_duration_parser.dart';

class VideoCastPlayer extends StatelessWidget {
  const VideoCastPlayer({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Expanded(
                  child: Slider(
                    value: controller.videoProgress,
                    onChanged: controller.onProgressChange,
                    onChangeStart: controller.startChangeProgress,
                    onChangeEnd: controller.endChangeProgress,
                  ),
                ),
                Text(
                  '${duration(controller.currentMediaStatus?.currentTime ?? Duration.zero)}/${duration(
                    controller.currentMediaStatus?.media?.duration ??
                        Duration.zero,
                  )}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
              right: 0,
              top: 0,
              bottom: 40,
              child: Column(
                children: [
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Slider(
                        onChanged: (double value) {},
                        value: 0,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: controller.toggleMute,
                      icon: Icon(
                        Icons.volume_up,
                        color: Colors.white,
                      ))
                ],
              ))
        ],
      ),
    );
  }

  String duration(Duration duration) {
    return '${duration.inMinutes % 60}:${duration.inSeconds % 60}';
  }
}
