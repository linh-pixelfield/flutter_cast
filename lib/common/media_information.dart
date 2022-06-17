import 'dart:convert';
import 'package:cast/cast_status/utils/utils.dart';
import 'package:cast/common/break.dart';
import 'package:cast/common/break_clips.dart';
import 'package:cast/common/hls_segment_format.dart';
import 'package:cast/common/hls_video_segment_format.dart';
import 'package:cast/common/media_metadata/cast_media_metadata.dart';
import 'package:cast/common/text_track_style.dart';
import 'package:cast/common/track.dart';
import 'package:cast/common/user_action_state.dart';
import 'package:cast/common/vast_ads_request.dart';
import '../cast_status/media_status/enums/stream_type.dart';

class CastMediaInformation {
  ///Alternate entity to be used to load the media in Android TV app.
  ///If set, this will override the value set in entity if the
  ///receiver is an Android TV app. On the receiver side, the
  ///entity can be accessed from MediaInfo#getEntity().
  final String? atvEntity;

  ///Partial list of break clips that includes current break clip
  /// that receiver is playing or ones that receiver will play
  ///  shortly after, instead of sending whole list of
  /// clips. This is to avoid overflow of MediaStatus message.
  final List<CastBreakClips>? breakClips;

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

  ///List of breaks.
  final List<CastBreak>? breaks;

  ///Optional media URL, to allow using contentId for real
  ///ID. If contentUrl is provided, it will be used
  ///as media URL, otherwise the contentId will
  ///be used as the media URL.
  final String? contentUrl;

  /// Optional media entity, commonly a Google Assistant deep link.

  final String? entity;

  ///The format of the HLS audio segment.
  final CastHlsSegmentFormat? hlsSegmentFormat;

  ///The format of the HLS video segment.
  final HlsVideoSegmentFormat? hlsVideoSegmentFormat;

  ///Provides absolute time (Epoch Unix time in seconds)
  ///for live streams. For live event it
  ///would be the time the event started,
  ///otherwise it will be start of the
  ///seekable range when the streaming started.

  final DateTime? startAbsoluteTime;

  ///The requested text track style. If not provided,
  /// the device style preferences (if existing) will be used.

  final TextTrackStyle? textTrackStyle;

  /// Array of Track objects.
  final List<Track>? tracks;

  /// Indicates the user action state for media.
  /// Indicate user like, dislike, or
  /// follow actions for the media.

  final List<UserActionState>? userActionStates;

  ///VMAP ad request configuration. Used if breaks and breakClips are not provided.

  final VastAdsRequest? vmapAdsRequest;

  CastMediaInformation({
    this.atvEntity,
    this.breakClips,
    required this.contentId,
    required this.streamType,
    required this.contentType,
    this.metadata,
    this.duration,
    this.customData,
    this.breaks,
    this.contentUrl,
    this.entity,
    this.hlsSegmentFormat,
    this.hlsVideoSegmentFormat,
    this.startAbsoluteTime,
    this.textTrackStyle,
    this.tracks,
    this.userActionStates,
    this.vmapAdsRequest,
  });

  Map<String, dynamic> toMap() {
    return {
      'atvEntity': atvEntity,
      'breakClips': breakClips?.map((x) => x.toMap()).toList(),
      'contentId': contentId,
      'streamType': streamType.value,
      'contentType': contentType,
      'metadata': metadata?.toMap(),
      'duration': duration?.inSeconds,
      'customData': customData,
      'breaks': breaks?.map((x) => x.toMap()).toList(),
      'contentUrl': contentUrl,
      'entity': entity,
      'hlsSegmentFormat': hlsSegmentFormat?.name,
      'hlsVideoSegmentFormat': hlsVideoSegmentFormat?.name,
      'startAbsoluteTime': startAbsoluteTime?.millisecondsSinceEpoch,
      'textTrackStyle': textTrackStyle?.toMap(),
      'tracks': tracks?.map((x) => x.toMap()).toList(),
      'userActionStates': userActionStates?.map((x) => x.toMap()).toList(),
      'vmapAdsRequest': vmapAdsRequest?.toMap(),
    }..removeWhere((key, value) => value == null);
  }

  factory CastMediaInformation.fromMap(Map<String, dynamic> map) {
    return CastMediaInformation(
      atvEntity: map['atvEntity'],
      breakClips: map['breakClips'] != null
          ? List<CastBreakClips>.from(
              map['breakClips']?.map((x) => CastBreakClips.fromMap(x)))
          : null,
      contentId: map['contentId'] ?? '',
      streamType: CastMediaStreamType.fromMap(map['streamType']),
      contentType: map['contentType'] ?? '',
      metadata: map['metadata'] != null
          ? getCastMediaMetadata(map['metadata'])
          : null,
      duration: map['duration'] != null
          ? Duration(seconds: map['duration'].round())
          : null,
      customData: Map<String, dynamic>.from(map['customData'] ?? {}),
      breaks: map['breaks'] != null
          ? List<CastBreak>.from(
              map['breaks']?.map((x) => CastBreak.fromMap(x)))
          : null,
      contentUrl: map['contentUrl'],
      entity: map['entity'],
      hlsSegmentFormat: map['hlsSegmentFormat'] != null
          ? CastHlsSegmentFormat.fromMap(map['hlsSegmentFormat'])
          : null,
      hlsVideoSegmentFormat: map['hlsVideoSegmentFormat'] != null
          ? HlsVideoSegmentFormat.fromMap(map['hlsVideoSegmentFormat'])
          : null,
      startAbsoluteTime: map['startAbsoluteTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startAbsoluteTime'])
          : null,
      textTrackStyle: map['textTrackStyle'] != null
          ? TextTrackStyle.fromMap(map['textTrackStyle'])
          : null,
      tracks: map['tracks'] != null
          ? List<Track>.from(map['tracks']?.map((x) => Track.fromMap(x)))
          : null,
      userActionStates: map['userActionStates'] != null
          ? List<UserActionState>.from(
              map['userActionStates']?.map((x) => UserActionState.fromMap(x)))
          : null,
      vmapAdsRequest: map['vmapAdsRequest'] != null
          ? VastAdsRequest.fromMap(map['vmapAdsRequest'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CastMediaInformation.fromJson(String source) =>
      CastMediaInformation.fromMap(json.decode(source));
}
