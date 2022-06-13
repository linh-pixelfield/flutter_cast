import 'dart:convert';

import 'package:example/models/video_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

class GalleryController extends GetxController {
  Future<VideoModels> getVideos() async {
    final json = await rootBundle.loadString('assets/videos.json');
    final data = jsonDecode(json);
    final videos = List.from(data).map((e) => VideoModel.fromMap(e)).toList();
    return videos;
  }

  void openVideo(VideoModel video) {
    Get.back(result: video);
  }
}
