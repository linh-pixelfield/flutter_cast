import 'dart:convert';

import 'package:example/models/video_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

class GalleryController extends GetxController {
  final List<VideoModel> selectedVideos = [];
  Future<VideoModels> getVideos() async {
    final json = await rootBundle.loadString('assets/videos.json');
    final data = jsonDecode(json);
    final videos = List.from(data).map((e) => VideoModel.fromMap(e)).toList();
    return videos;
  }

  void selectVideo(VideoModel video) {
    if (selectedVideos.contains(video)) {
      selectedVideos.remove(video);
    } else {
      selectedVideos.add(video);
    }
    update();
  }

  void resultItems() {
    Get.back(result: selectedVideos);
  }
}
