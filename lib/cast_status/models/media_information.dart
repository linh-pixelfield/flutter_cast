import 'dart:convert';

import 'package:cast/cast_events/models/media_metadata/cast_media_metadata.dart';
import 'package:cast/cast_events/models/stream_type.dart';

/// This data structure describes a media stream.
class CastMediaInformation {
  ///Service-specific identifier of the content currently
  ///loaded by the media player. This is a free form
  /// string and is specific to the application.
  ///  In most cases, this will be the URL to the
  ///  media, but the sender can choose to pass
  /// a string that the receiver can interpret
  ///  properly. Max length: 1k
  final String contentId;

  ///Describes the type of media artifact
  final CastStreamType streamType;

  ///MIME content type of the media being played
  ///
  ///Image formats: APNG, BMP, GIF, JPEG, PNG, WEBP;
  ///
  ///Media container: formats  MP2T MP3 MP4 OGG WAV WebM;
  ///
  ///Video codecs see: https://developers.google.com/cast/docs/media#video_codecs;
  ///
  ///Audio codecs see: https://developers.google.com/cast/docs/media#audio_codecs;

  final String contentType;

  ///optional The media metadata object, one of the following:
  final CastMediaMetadata? metadata;

  /// Duration of the currently playing stream in seconds
  Duration? duration;

  ///optional Application-specific blob
  /// of data defined by either the sender
  ///  application or the receiver application
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

  String toJson() => json.encode(toMap());
}
