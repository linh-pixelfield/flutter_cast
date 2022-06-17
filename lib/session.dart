import 'dart:async';

import 'package:cast/cast.dart';
import 'package:cast/common/cast_status_event.dart';
import 'package:cast/cast_status/media_status/cast_media_status.dart';

import 'device.dart';
import 'socket.dart';

enum CastSessionState {
  connecting,
  connected,
  closed,
}

class CastSession {
  static const kNamespaceConnection =
      'urn:x-cast:com.google.cast.tp.connection';
  static const kNamespaceHeartbeat = 'urn:x-cast:com.google.cast.tp.heartbeat';
  static const kNamespaceReceiver = 'urn:x-cast:com.google.cast.receiver';
  static const kNamespaceDeviceauth =
      'urn:x-cast:com.google.cast.tp.deviceauth';
  static const kNamespaceMedia = 'urn:x-cast:com.google.cast.media';

  final String sessionId;
  CastSocket get socket => _socket;
  CastSessionState get state => _state;

  Stream<CastSessionState> get stateStream => _stateController.stream;
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<List<CastMediaStatus>> get mediaStatusStream =>
      _mediaStatusController.stream;
  Stream<CastReceiverStatus> get receiverStatusStream =>
      _receiverStatusController.stream;

  final CastSocket _socket;
  CastSessionState _state = CastSessionState.connecting;
  String? _transportId;

  final _stateController = StreamController<CastSessionState>.broadcast();
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _mediaStatusController =
      StreamController<List<CastMediaStatus>>.broadcast();
  final _receiverStatusController =
      StreamController<CastReceiverStatus>.broadcast();

  CastSession._(this.sessionId, this._socket);

  static Future<CastSession> connect(String sessionId, CastDevice device,
      [Duration? timeout]) async {
    final _socket = await CastSocket.connect(
      device.host,
      device.port,
      timeout,
    );

    final session = CastSession._(sessionId, _socket);

    session._startListening();

    session.sendMessage(kNamespaceConnection, {
      'type': 'CONNECT',
    });

    return session;
  }

  Future<dynamic> close() async {
    if (_socket.isClosed) return;
    if (!_messageController.isClosed) {
      sendMessage(kNamespaceConnection, {
        'type': 'CLOSE',
      });
      try {
        await _socket.flush();
      } catch (_error) {}
    }
    return _socket.close();
  }

  void _startListening() {
    _socket.stream.listen((message) {
      // happen
      if (_messageController.isClosed) {
        return;
      }

      if (message.namespace == kNamespaceHeartbeat &&
          message.payload['type'] == 'PING') {
        sendMessage(kNamespaceHeartbeat, {
          'type': 'PONG',
        });
      } else if (message.namespace == kNamespaceConnection &&
          message.payload['type'] == 'CLOSE') {
        close();
      } else if (message.namespace == kNamespaceReceiver &&
          message.payload['type'] == 'RECEIVER_STATUS') {
        _receiverStatusController
            .add(CastReceiverStatus.fromMap(message.payload));
        _handleReceiverStatus(message.payload);

        _messageController.add(message.payload);
      } else if (message.payload['type'] ==
          CastStatusType.mediaStatus.rawValue) {
        final mediaEvents = List.from(message.payload['status'])
            .map((e) => CastMediaStatus.fromMap(e))
            .toList();
        _mediaStatusController.add(mediaEvents);
      } else {
        _messageController.add(message.payload);
      }
    }, onError: (error) {
      _messageController.addError(error);
    }, onDone: () {
      _messageController.close();

      _state = CastSessionState.closed;
      _stateController.add(_state);
      _stateController.close();
      _mediaStatusController.close();
    }, cancelOnError: false);
  }

  void _handleReceiverStatus(Map<String, dynamic> payload) {
    if (_transportId != null) {
      return;
    }

    if (payload['status']?.containsKey('applications') == true) {
      _transportId = payload['status']['applications'][0]['transportId'];

      // reconnect with new _transportId
      sendMessage(kNamespaceConnection, {
        'type': 'CONNECT',
      });

      _state = CastSessionState.connected;
      _stateController.add(_state);
    }
  }

  void sendMessage(String namespace, Map<String, dynamic> payload) {
    _socket.sendMessage(
      namespace,
      sessionId,
      _transportId ?? 'receiver-0',
      payload,
    );
  }

  Future<T> sendMediaCommand<T>(CastMediaCommand<T> command) async {
    StreamSubscription? subscription;
    final completer = Completer();
    final timer = Timer.periodic(Duration(seconds: 15), (timer) {
      timer.cancel();
      completer.completeError('timeout :15 seconds');
      subscription?.cancel();
    });
    subscription = _socket.stream.listen(
      (event) => completer.complete(
        command.decodeResponse(event.payload),
      ),
    );
    sendMessage(
      kNamespaceMedia,
      command.toMap(),
    );

    final result = await completer.future;
    timer.cancel();
    await subscription.cancel();

    return result;
  }

  void sendReceiverCommand(CastReceiverCommand command) {
    sendMessage(
      kNamespaceReceiver,
      command.toMap(),
    );
  }

  Future<dynamic> flush() {
    return _socket.flush();
  }
}
