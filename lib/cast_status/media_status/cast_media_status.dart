import 'dart:convert';
import 'models/medial_information.dart';
import 'supported_media_commands.dart';

class CastMediaStatus {
  CastMediaStatus({
    required this.mediaSessionId,
    required this.playbackRate,
    required this.playerState,
    this.idleReason,
    required this.supportedMediaCommands,
    required this.volume,
    this.media,
    required this.currentTime,
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

  ///optional (for status messages) Full description of the content that is being played back. Only be returned in a status messages if the MediaInformation has changed.
  final CastMediaMedialInformation? media;

  Map<String, dynamic> toMap() {
    return {
      'mediaSessionId': mediaSessionId,
      'playbackRate': playbackRate,
      'playerState': playerState.rawValue,
      'idleReason': idleReason?.value,
      'currentTime': currentTime.inSeconds,
      'supportedMediaCommands':
          supportedMediaCommands.map((e) => e.value).toList(),
      'volume': volume.toMap(),
      'media': media?.toMap(),
    };
  }

  factory CastMediaStatus.fromMap(Map<String, dynamic> map) {
    return CastMediaStatus(
      mediaSessionId: map['mediaSessionId']?.toInt() ?? 0,
      currentTime: Duration(seconds: map['currentTime']?.toInt() ?? 0),
      playbackRate: map['playbackRate'] ?? 0,
      playerState: CastMediaPlayerState.fromString(map['playerState']),
      idleReason: map['idleReason'] != null
          ? CastMediaIdleReason.fromString(map['idleReason'])
          : null,
      supportedMediaCommands:
          SupportedMediaCommand.fromInt(map['supportedMediaCommands']),
      volume: CastMediaVolume.fromMap(map['volume']),
      media: map['media'] != null
          ? CastMediaMedialInformation.fromMap(map['media'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CastMediaStatus.fromJson(String source) =>
      CastMediaStatus.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CastMediaStatusEvent(mediaSessionId: $mediaSessionId, playbackRate: $playbackRate, playerState: $playerState, idleReason: $idleReason, supportedMediaCommands: $supportedMediaCommands, volume: $volume, media: $media)';
  }
}
