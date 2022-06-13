import 'package:example/models/video_model.dart';
import 'package:example/views/gallery/gallery_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GalleryController>(
        init: GalleryController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Gallery'),
            ),
            body: FutureBuilder<VideoModels>(
              future: controller.getVideos(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error.toString()}',
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final videos = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return ListTile(
                      leading: Image.network(video.thumbnailUrl),
                      title: Text(video.title),
                      subtitle: Text(video.author),
                      onTap: () {
                        controller.openVideo(video);
                      },
                    );
                  },
                );
              },
            ),
          );
        });
  }
}
