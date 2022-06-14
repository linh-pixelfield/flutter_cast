import 'dart:convert';

import 'package:equatable/equatable.dart';

typedef VideoModels = List<VideoModel>;

class VideoModel extends Equatable {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String duration;
  final String uploadTime;
  final String views;
  final String author;
  final String videoUrl;
  final String description;
  final String subscriber;
  final bool isLive;
  VideoModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.uploadTime,
    required this.views,
    required this.author,
    required this.videoUrl,
    required this.description,
    required this.subscriber,
    required this.isLive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'uploadTime': uploadTime,
      'views': views,
      'author': author,
      'videoUrl': videoUrl,
      'description': description,
      'subscriber': subscriber,
      'isLive': isLive,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      duration: map['duration'] ?? '',
      uploadTime: map['uploadTime'] ?? '',
      views: map['views'] ?? '',
      author: map['author'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      description: map['description'] ?? '',
      subscriber: map['subscriber'] ?? '',
      isLive: map['isLive'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(json.decode(source));

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
