import 'dart:async';
import 'package:cast/cast.dart';
import 'package:example/models/video_model.dart';
import 'package:example/views/devices_bottom_sheet/devices_bottom_sheet_view.dart';
import 'package:example/views/gallery/gallery_view.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:mime/mime.dart';

class PlayerController extends GetxController {
  CastSession? _currentSession;
  StreamSubscription<List<CastMediaStatus>>? _mediaStatusSubscription;
  StreamSubscription<CastSessionState>? _sessionStateSubscription;
  StreamSubscription<CastReceiverStatus>? _receiverStatusSubscription;
  CastMediaVolume? deviceVolume;
  bool get activeSession => _currentSession != null;
  Timer? _videoTickerTimer;
  bool isChangeProgress = false;
  double _progress = 0.0;
  double beforeMuteVolume = 0.0;
  Duration? currentVideoDuration;
  CastMediaStatus? currentMediaStatus;
  bool _isVolumeChanging = false;
  double _volumeLevel = 0;
  bool get existentMediaSession => currentMediaStatus != null;
  double get volumeLevel => _volumeLevel;
  double get videoProgress => _progress;

  void openCastDevices() async {
    final session = await CastDevicesBottomSheet.show();
    if (session != null) {
      _setUpCastDevice(session);
    }
  }

  void _setUpCastDevice(CastSession session) {
    _currentSession = session;
    _mediaStatusSubscription =
        _currentSession?.mediaStatusStream.listen(_listenEvents);

    _sessionStateSubscription =
        _currentSession?.stateStream.listen(_listenSessionsState);

    _receiverStatusSubscription =
        _currentSession?.receiverStatusStream.listen(_listenReceiverStatus);
    _currentSession?.messageStream.listen(_printRawMessages);
    // _videoTickerTimer = Timer.periodic(
    //   const Duration(seconds: 1),
    //   (timer) {
    //     _currentSession?.sendMediaCommand(CastGetStatusCommand());
    //   },
    // );
    update();
  }

  closeSession() {
    _currentSession?.close();
    _currentSession = null;
    update();
  }

  void openGallery() async {
    final videos = await Get.to<List<VideoModel>?>(() => const GalleryView());
    if (videos == null || videos.isEmpty) return;
    final queueItems = videos
        .map(
          (e) => CastQueueItem(
            media: CastMediaInformation(
                contentId: e.videoUrl,
                streamType: CastMediaStreamType.BUFFERED,
                contentType: lookupMimeType(e.videoUrl) ?? ''),
            preloadTime: const Duration(seconds: 15),
          ),
        )
        .toList();
    if (!existentMediaSession) {
      _currentSession?.sendMediaCommand(
        CastLoadCommand(
          autoplay: true,
          queueData: CastQueueData(
            items: queueItems,
          ),
        ),
      );
    } else {
      _currentSession?.sendMediaCommand(
        CastQueueInsertItemsCommand(
          items: queueItems,
          mediaSessionId: currentMediaStatus?.mediaSessionId ?? 1,
        ),
      );
    }
  }

  void _listenEvents(List<CastMediaStatus> events) {
    if (events.isEmpty) {
      currentMediaStatus = null;
      return;
    }
    _onChangeProgress(events);
    update();
  }

  _onChangeProgress(List<CastMediaStatus> events) {
    currentMediaStatus = events.first;
    print('currentMediaStatus: ${currentMediaStatus?.toJson()}');
    if (!isChangeProgress) {
      int mediaDuration = (events.first.media?.duration?.inMilliseconds ?? 0);
      if (mediaDuration == 0) return;
      currentVideoDuration = Duration(milliseconds: mediaDuration);
      _progress = events.first.currentTime.inMilliseconds / mediaDuration;
    }
  }

  void _listenSessionsState(CastSessionState event) {
    switch (event) {
      case CastSessionState.closed:
        _videoTickerTimer?.cancel();
        _mediaStatusSubscription?.cancel();
        _sessionStateSubscription?.cancel();
        _receiverStatusSubscription?.cancel();
        _currentSession = null;

        _progress = 0;

        update();

        break;
      default:
    }
  }

  void onProgressChange(double value) {
    _progress = value;
    update();
  }

  void startChangeProgress(double value) {
    isChangeProgress = true;
  }

  void endChangeProgress(double value) {
    final duration =
        ((currentVideoDuration?.inMilliseconds ?? 0) * value).round();

    _currentSession?.sendMediaCommand(
      CastSeekCommand(
        mediaSessionId: currentMediaStatus?.mediaSessionId ?? 1,
        currentTime: Duration(milliseconds: duration),
      ),
    );
    isChangeProgress = false;
  }

  void toggleMute() {
    if (deviceVolume == null) return;
    final isMuted = deviceVolume!.muted ?? false;
    double volumeLevel = deviceVolume!.level?.toDouble() ?? 0.0;
    if (isMuted) {
      volumeLevel = beforeMuteVolume;
    } else {
      beforeMuteVolume = volumeLevel;
    }
    _currentSession?.sendReceiverCommand(
        CastSetVolumeCommand(volume: CastMediaVolume(volumeLevel, !isMuted)));
  }

  void _listenReceiverStatus(CastReceiverStatus receiverStatus) {
    deviceVolume = receiverStatus.status.volume;
    if (!_isVolumeChanging) {
      _volumeLevel = deviceVolume?.level?.toDouble() ?? 0.0;
    }
    update();
  }

  void onVolumeChangeEnd(double value) async {
    _isVolumeChanging = false;
    _currentSession?.sendReceiverCommand(
      CastSetVolumeCommand(
        volume: CastMediaVolume(value, value == 0),
      ),
    );
  }

  void onVolumeChangeStart(double value) {
    _isVolumeChanging = true;
  }

  void onVolumeChange(double value) {
    _volumeLevel = value;
    update();
  }

  void togglePlayPause() {
    if (currentMediaStatus == null) return;
    final isPlaying =
        currentMediaStatus!.playerState == CastMediaPlayerState.playing;
    if (isPlaying) {
      _currentSession?.sendMediaCommand(
          CastPauseCommand(mediaSessionId: currentMediaStatus!.mediaSessionId));
    } else {
      _currentSession?.sendMediaCommand(
          CastPlayCommand(mediaSessionId: currentMediaStatus!.mediaSessionId));
    }
  }

  void _printRawMessages(Map<String, dynamic> event) {
    print(event);
  }
}
