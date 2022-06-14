import 'dart:convert';

import 'package:cast/cast_status/utils/utils.dart';
import 'package:cast/common/media_metadata/cast_media_metadata.dart';

import '../cast_status/media_status/enums/stream_type.dart';

class CastMediaInformation {
  ///Service-specific identifier of the content currently loaded
  /// by the media player. This is a free form string and is specific
  ///  to the application. In most cases, this will be the URL to the
  ///  media, but the sender can choose to pass a string that the receiver can
  ///  interpret properly. Max length: 1k
  final String contentId;

  ///Describes the type of media artifact as one of the following:

  ///NONE
  ///BUFFERED
  ///LIVE
  final CastMediaStreamType streamType;

  ///MIME content type of the media being played
  final String contentType;

  ///The media metadata object, one of the following:

  ///0  GenericMediaMetadata
  ///1  MovieMediaMetadata
  ///2  TvShowMediaMetadata
  ///3  MusicTrackMediaMetadata
  ///4  PhotoMediaMetadata
  final CastMediaMetadata? metadata;

  ///optional Duration of the currently playing stream in seconds
  final Duration? duration;

  ///optional Application-specific blob of data defined by either the sender application or the receiver application
  final Map<String, dynamic>? customData;

  CastMediaInformation({
    required this.contentId,
    required this.streamType,
    required this.contentType,
    this.metadata,
    this.duration,
    this.customData,
  });

  Map<String, dynamic> toMap() {
    return {
      'contentId': contentId,
      'streamType': streamType.value,
      'contentType': contentType,
      'metadata': metadata?.toMap(),
      'duration': duration?.inSeconds,
      'customData': customData,
    };
  }

  factory CastMediaInformation.fromMap(Map<String, dynamic> map) {
    return CastMediaInformation(
      contentId: map['contentId'] ?? '',
      streamType: CastMediaStreamType.fromString(map['streamType']),
      contentType: map['contentType'] ?? '',
      metadata: map['metadata'] != null
          ? getCastMediaMetadata(map['metadata'])
          : null,
      duration: Duration(seconds: map['duration']?.toInt() ?? 0),
      customData: map['customData'] != null
          ? Map<String, dynamic>.from(map['customData'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CastMediaInformation.fromJson(String source) =>
      CastMediaInformation.fromMap(json.decode(source));
}
