import 'dart:async';

import 'package:example/views/player/player_view.dart';
import 'package:flutter/material.dart';
import 'package:cast/cast.dart';
import 'package:get/route_manager.dart';

void main() {
  runApp(const GetMaterialApp(
    home: PlayerView(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cast Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<CastDevice>>? _future;
  CastDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _startSearch();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CastDevice>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error.toString()}',
            ),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.isEmpty) {
          return Column(
            children: [
              Center(
                child: Text(
                  'No Chromecast founded',
                ),
              ),
            ],
          );
        }

        return Column(
          children: snapshot.data!.map((device) {
            return ListTile(
              title: Text(device.name),
              onTap: () {
                _connectToYourApp(context, device);
                // _connectAndPlayMedia(context, device);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _startSearch() {
    _future = CastDiscoveryService().search();
  }

  Future<void> _connectToYourApp(
      BuildContext context, CastDevice object) async {
    print('start connect');
    final session = await CastSessionManager().startSession(object);
    final completer = Completer();
    final subscription = session.stateStream.listen((state) {
      print(state);
      if (state == CastSessionState.connected) {
        final snackBar = SnackBar(content: Text('Connected'));
        Scaffold.of(context).showSnackBar(snackBar);
        completer.complete(state);

        _sendMessageToYourApp(session);
      }
    });

    session.messageStream.listen((message) {
      print('receive message: $message');
    });
    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'CC1AD845', // set the appId of your app here
    });
    await completer.future;

    _sendMessagePlayVideo(session);

    await Future.delayed(Duration(seconds: 8));
  }

  void _sendMessageToYourApp(CastSession session) {
    print('_sendMessageToYourApp');

    session.sendMessage(
      'urn:x-cast:namespace-of-the-app',
      {
        'type': 'sample',
      },
    );
  }

  Future<void> _connectAndPlayMedia(
      BuildContext context, CastDevice object) async {
    final session = await CastSessionManager().startSession(object);

    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        final snackBar = SnackBar(content: Text('Connected'));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    });

    session.messageStream.listen((message) {
      print('receive message: $message');

      Future.delayed(Duration(seconds: 5)).then((x) {
        _sendMessagePlayVideo(session);
      });
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'CC1AD845', // set the appId of your app here
    });
  }

  void _sendMessagePlayVideo(CastSession session) {
    final movieMediaInformation = CastMediaInformation(
      contentId:
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/big_buck_bunny_1080p.mp4',
      streamType: CastStreamType.buffered,
      contentType: 'video/mp4',
      metadata: CastMovieMediaMetadata(
        studio: 'Studios Gibli',
        images: [
          CastImage(
            url: Uri.parse(
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
            ),
          )
        ],
        releaseDate: DateTime(2015, 01, 01),
        subtitle: 'By Blender Foundation',
        title: 'Big Buck Bunny',
      ),
    );
    final tvShowMediaInformation = CastMediaInformation(
      contentId:
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/big_buck_bunny_1080p.mp4',
      streamType: CastStreamType.buffered,
      contentType: 'video/mp4',
      metadata: CastTvShowMediaMetadata(
        episode: 3,
        originalAirDate: DateTime(2015, 01, 01),
        season: 3,
        images: [
          CastImage(
            url: Uri.parse(
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
            ),
          )
        ],
        subtitle: 'By Blender Foundation',
        seriesTitle: 'Big Buck Bunny',
      ),
    );

    session.sendMediaCommand(
      CastLoadCommand(
        media: tvShowMediaInformation,
        autoplay: true,
        currentTime: const Duration(seconds: 10),
      ),
    );

    Timer.periodic(const Duration(seconds: 1), (timer) {
      session.sendMediaCommand(CastGetStatusCommand());
    });

    // Future.delayed(
    //   const Duration(seconds: 8),
    //   () {
    //     session.sendMediaCommand(
    //       CastSeekCommand(
    //         mediaSessionId: 1,
    //         currentTime: const Duration(seconds: 31),
    //         resumeState: CastResumeState.PLAYBACK_START,
    //       ),
    //     );
    //   },
    // );

    Future.delayed(
      const Duration(seconds: 10),
      () {
        session.sendReceiverCommand(CastSetVolumeCommand(
          volume: CastMediaVolume(1, true),
        ));
      },
    );
    Future.delayed(
      const Duration(seconds: 12),
      () {
        session.sendReceiverCommand(
            CastSetVolumeCommand(volume: CastMediaVolume(0.5, false)));
      },
    );
    session.mediaStatusStream.listen((event) {
      print('receive event: $event');
    });
  }
}
