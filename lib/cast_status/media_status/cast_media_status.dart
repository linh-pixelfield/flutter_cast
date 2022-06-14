import 'dart:convert';
import 'package:cast/cast_status/media_status/enums/player_state.dart';
import 'package:cast/cast_status/media_status/models/break_status.dart';
import 'package:cast/cast_status/media_status/models/idle_reason.dart';
import 'package:cast/common/live_seekable_range.dart';
import 'package:cast/common/queue_data.dart';
import 'package:cast/common/volume.dart';
import 'package:collection/collection.dart';
import '../../common/media_information.dart';
import 'supported_media_commands.dart';

class CastMediaStatus {
  CastMediaStatus({
    required this.mediaSessionId,
    required this.playbackRate,
    required this.playerState,
    this.idleReason,
    required this.currentTime,
    required this.supportedMediaCommands,
    required this.volume,
    this.media,
    this.items,
    this.activeTrackIds,
    required this.breakStatus,
    this.currentItemId,
    this.liveSeekableRange,
    this.loadingItemId,
    this.preloadedItemId,
    this.queueData,
    required this.repeatMode,
  });

  ///Unique ID for the playback of this specific session. This ID is
  /// set by the receiver at LOAD and can be used to identify a
  /// specific instance of a playback. For example, two playbacks of
  ///  "Wish you were here" within the same session would each have
  ///  a unique mediaSessionId.
  final int mediaSessionId;

  ///Indicates whether the media time is progressing, and at what
  /// rate. This is independent of the player state since the media
  /// time can stop in any state. 1.0 is regular time, 0.5 is slow motion
  final num playbackRate;

  ///Describes the state of the player as one of the following:[CastMediaPlayerState]
  final CastMediaPlayerState playerState;
  //////optional If the playerState is IDLE and the reason it
  ///became IDLE is known, this property is provided. If the
  /// player is IDLE because it just started, this property
  /// will not be provided; if the player is in any other
  /// state this property should not be provided.
  ///  The following values apply:
  final CastMediaIdleReason? idleReason;

  ///The current position of the media player since
  /// the beginning of the content, in seconds.
  ///  If this a live stream content, then this
  /// field represents the time in seconds from
  /// the beginning of the event that should be
  ///  known to the player.
  final Duration currentTime;

  ///Flags describing which media commands the media player supports: [SupportedMediaCommands]
  final SupportedMediaCommands supportedMediaCommands;

  ///Stream volume
  final CastMediaVolume volume;

  ///optional (for status messages) Full description of
  ///the content that is being played back.
  ///Only be returned in a status messages
  ///if the MediaInformation has changed.
  final CastMediaInformation? media;

  final List<CastQueueItem>? items;

  ///List of IDs corresponding to the active Tracks.
  final List<int>? activeTrackIds;

  ///Status of a break when a break is playing
  /// on the receiver. This field will be
  /// defined when the receiver is playing
  /// a break, empty when a break is not playing,
  ///  but is present in the content, and
  /// undefined if the content contains
  /// no breaks.
  final CastBrakeStatus? breakStatus;

  ///Item ID of the item that
  /// was active in the queue (it may not be playing)
  ///  at the time the media status change happened.
  final int? currentItemId;

  ///Seekable range of a live or event stream. I
  ///t uses relative media time in seconds.
  ///It will be undefined for VOD streams.
  final CastLiveSeekableRange? liveSeekableRange;

  ///Item ID of the item that is currently loading
  /// on the receiver. Null if no item is currently
  /// loading.
  final int? loadingItemId;

  ///ID of the next Item, only available if it has
  /// been preloaded. On the receiver media items
  /// can be preloaded and cached temporarily in
  /// memory, so when they are loaded later on,
  /// the process is faster (as the media does
  /// not have to be fetched from the network).
  final int? preloadedItemId;

  /// Queue data
  final CastQueueData? queueData;

  ///The repeat mode for playing the queue.
  final QueueRepeatMode repeatMode;

  Map<String, dynamic> toMap() {
    return {
      'mediaSessionId': mediaSessionId,
      'playbackRate': playbackRate,
      'playerState': playerState.rawValue,
      'idleReason': idleReason?.value,
      'currentTime': currentTime.inSeconds,
      'supportedMediaCommands':
          supportedMediaCommands.map((e) => e.value).toList().sum,
      'volume': volume.toMap(),
      'media': media?.toMap(),
      'items': items?.map((x) => x.toMap()).toList(),
      'activeTrackIds': activeTrackIds,
      'breakStatus': breakStatus?.toMap(),
      'currentItemId': currentItemId,
      'liveSeekableRange': liveSeekableRange?.toMap(),
      'loadingItemId': loadingItemId,
      'preloadedItemId': preloadedItemId,
      'queueData': queueData?.toMap(),
      'repeatMode': repeatMode.name,
    };
  }

  factory CastMediaStatus.fromMap(Map<String, dynamic> map) {
    return CastMediaStatus(
      mediaSessionId: map['mediaSessionId']?.toInt() ?? 0,
      playbackRate: map['playbackRate'] ?? 0,
      playerState: CastMediaPlayerState.fromMap(map['playerState']),
      idleReason: map['idleReason'] != null
          ? CastMediaIdleReason.fromMap(map['idleReason'])
          : null,
      currentTime: Duration(seconds: map['currentTime']?.toInt() ?? 0),
      supportedMediaCommands:
          SupportedMediaCommand.fromMap(map['supportedMediaCommands']),
      volume: CastMediaVolume.fromMap(map['volume']),
      media: map['media'] != null
          ? CastMediaInformation.fromMap(map['media'])
          : null,
      items: map['items'] != null
          ? List<CastQueueItem>.from(
              map['items']?.map((x) => CastQueueItem.fromMap(x)))
          : null,
      activeTrackIds: List<int>.from(map['activeTrackIds'] ?? []),
      breakStatus: map['breakStatus'] != null
          ? CastBrakeStatus.fromMap(map['breakStatus'])
          : null,
      currentItemId: map['currentItemId']?.toInt(),
      liveSeekableRange: map['liveSeekableRange'] != null
          ? CastLiveSeekableRange.fromMap(map['liveSeekableRange'])
          : null,
      loadingItemId: map['loadingItemId']?.toInt(),
      preloadedItemId: map['preloadedItemId']?.toInt(),
      queueData: map['queueData'] != null
          ? CastQueueData.fromMap(map['queueData'])
          : null,
      repeatMode: QueueRepeatMode.fromMap(map['repeatMode']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CastMediaStatus.fromJson(String source) =>
      CastMediaStatus.fromMap(json.decode(source));
}
