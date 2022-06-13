import 'dart:async';

import 'package:cast/cast.dart';
import 'package:cast/cast_events/cast_media_status_message_event/cast_media_status_message_event.dart';
import 'package:example/models/video_model.dart';
import 'package:example/views/devices_bottom_sheet/devices_bottom_sheet_view.dart';
import 'package:example/views/gallery/gallery_view.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:mime/mime.dart';

class PlayerController extends GetxController {
  CastSession? _currentSession;
  StreamSubscription<List<CastMediaStatusEvent>>? _mediaEventSubscription;
  StreamSubscription<CastSessionState>? _sessionStateSubscription;
  bool get activeSession => _currentSession != null;
  Timer? _videoTickerTimer;
  bool isChangeProgress = false;
  double _progress = 0.0;
  Duration? currentVideoDuration;
  CastMediaStatusEvent? currentMediaStatus;

  double get videoProgress => _progress;

  void openCastDevices() async {
    final session = await CastDevicesBottomSheet.show();
    if (session != null) {
      _setUpCastDevice(session);
    }
  }

  void _setUpCastDevice(CastSession session) {
    _currentSession = session;
    _mediaEventSubscription =
        _currentSession?.eventStream.listen(_listenEvents);

    _sessionStateSubscription =
        _currentSession?.stateStream.listen(_listenSessionsState);
    _videoTickerTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _currentSession?.sendMediaCommand(CastGetStatusCommand());
      },
    );
    update();
  }

  closeSession() {
    _currentSession?.close();
    _currentSession = null;
    update();
  }

  void openGallery() async {
    final video = await Get.to<VideoModel?>(() => const GalleryView());
    if (video != null) {
      final mimeType = lookupMimeType(video.videoUrl);
      _currentSession?.sendMediaCommand(
        CastLoadCommand(
          autoplay: true,
          media: CastMediaInformation(
            contentId: video.videoUrl,
            streamType: CastStreamType.buffered,
            contentType: mimeType ?? '',
            metadata: CastMovieMediaMetadata(
              images: [
                CastImage(
                  url: Uri.parse(video.thumbnailUrl),
                ),
              ],
              studio: video.author,
              title: video.title,
              subtitle: video.description,
            ),
          ),
        ),
      );
    }
  }

  void _listenEvents(List<CastMediaStatusEvent> events) {
    if (events.isEmpty) return;
    _onChangeProgress(events);
    update();
  }

  _onChangeProgress(List<CastMediaStatusEvent> events) {
    currentMediaStatus = events.first;
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
        _mediaEventSubscription?.cancel();
        _sessionStateSubscription?.cancel();
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
        mediaSessionId: 1,
        currentTime: Duration(milliseconds: duration),
      ),
    );
    isChangeProgress = false;
  }

  void toggleMute() {
    final currentVolume = currentMediaStatus?.volume;
    if (currentVolume == null) return;
    _currentSession?.sendReceiverCommand(CastSetVolumeCommand(
        volume: CastMediaVolume(
            currentVolume.level, !(currentVolume.muted ?? false))));
  }
}
