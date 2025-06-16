// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

/// An example of using the plugin, controlling lifecycle and playback of the
/// video.
library;

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(
    MaterialApp(
      home: _App(),
    ),
  );
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: const ValueKey<String>('home_page'),
        appBar: AppBar(
          title: const Text('Video player example'),
          actions: <Widget>[
            IconButton(
              key: const ValueKey<String>('push_tab'),
              icon: const Icon(Icons.navigation),
              onPressed: () {
                Navigator.push<_PlayerVideoAndPopPage>(
                  context,
                  // MaterialPageRoute<_PlayerVideoAndPopPage>(
                  //   builder: (BuildContext context) => _PlayerVideoAndPopPage(),
                  // ),
                  MaterialPageRoute<_PlayerVideoAndPopPage>(
                    builder: (BuildContext context) => MediaFlowVideoPage(),
                  ),
                );
              },
            )
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.cloud),
                text: 'Remote',
              ),
              Tab(icon: Icon(Icons.insert_drive_file), text: 'Asset'),
              Tab(icon: Icon(Icons.list), text: 'List example'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _ViewTypeTabBar(
              builder: (VideoViewType viewType) =>
                  _BumbleBeeRemoteVideo(viewType),
            ),
            _ViewTypeTabBar(
              builder: (VideoViewType viewType) =>
                  _ButterFlyAssetVideo(viewType),
            ),
            _ViewTypeTabBar(
              builder: (VideoViewType viewType) =>
                  _ButterFlyAssetVideoInList(viewType),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewTypeTabBar extends StatefulWidget {
  const _ViewTypeTabBar({
    required this.builder,
  });

  final Widget Function(VideoViewType) builder;

  @override
  State<_ViewTypeTabBar> createState() => _ViewTypeTabBarState();
}

class _ViewTypeTabBarState extends State<_ViewTypeTabBar>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.texture),
              text: 'Texture view',
            ),
            Tab(
              icon: Icon(Icons.construction),
              text: 'Platform view',
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              widget.builder(VideoViewType.textureView),
              widget.builder(VideoViewType.platformView),
            ],
          ),
        ),
      ],
    );
  }
}

class _ButterFlyAssetVideoInList extends StatelessWidget {
  const _ButterFlyAssetVideoInList(this.viewType);

  final VideoViewType viewType;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const _ExampleCard(title: 'Item a'),
        const _ExampleCard(title: 'Item b'),
        const _ExampleCard(title: 'Item c'),
        const _ExampleCard(title: 'Item d'),
        const _ExampleCard(title: 'Item e'),
        const _ExampleCard(title: 'Item f'),
        const _ExampleCard(title: 'Item g'),
        Card(
            child: Column(children: <Widget>[
          Column(
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.cake),
                title: Text('Video video'),
              ),
              Stack(
                  alignment: FractionalOffset.bottomRight +
                      const FractionalOffset(-0.1, -0.1),
                  children: <Widget>[
                    _ButterFlyAssetVideo(viewType),
                    Image.asset('assets/flutter-mark-square-64.png'),
                  ]),
            ],
          ),
        ])),
        const _ExampleCard(title: 'Item h'),
        const _ExampleCard(title: 'Item i'),
        const _ExampleCard(title: 'Item j'),
        const _ExampleCard(title: 'Item k'),
        const _ExampleCard(title: 'Item l'),
      ],
    );
  }
}

/// A filler card to show the video in a list of scrolling contents.
class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.airline_seat_flat_angled),
            title: Text(title),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OverflowBar(
              alignment: MainAxisAlignment.end,
              spacing: 8.0,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                TextButton(
                  child: const Text('SELL TICKETS'),
                  onPressed: () {
                    /* ... */
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ButterFlyAssetVideo extends StatefulWidget {
  const _ButterFlyAssetVideo(this.viewType);

  final VideoViewType viewType;

  @override
  _ButterFlyAssetVideoState createState() => _ButterFlyAssetVideoState();
}

class _ButterFlyAssetVideoState extends State<_ButterFlyAssetVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/Butterfly-209.mp4',
      viewType: widget.viewType,
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          const Text('With assets mp4'),
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _ControlsOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BumbleBeeRemoteVideo extends StatefulWidget {
  const _BumbleBeeRemoteVideo(this.viewType);

  final VideoViewType viewType;

  @override
  _BumbleBeeRemoteVideoState createState() => _BumbleBeeRemoteVideoState();
}

class _BumbleBeeRemoteVideoState extends State<_BumbleBeeRemoteVideo> {
  late VideoPlayerController _controller;

  Future<ClosedCaptionFile> _loadCaptions() async {
    final String fileContents = await DefaultAssetBundle.of(context)
        .loadString('assets/bumble_bee_captions.vtt');
    return WebVTTCaptionFile(
        fileContents); // For vtt files, use WebVTTCaptionFile
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
      closedCaptionFile: _loadCaptions(),
      videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: true
      ),
      viewType: VideoViewType.textureView,
        rect: Rect.fromLTWH(0, 100, 350, 350/1.777),
        // rect: Rect.fromLTWH(20, 309, 350, 350/1.777)
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((value){
      changeRect();
    });
  }
  GlobalKey playerKey = GlobalKey();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  changeRect(){
    final RenderBox? box = playerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      return;
    }
    final Offset offset = box.localToGlobal(Offset.zero);
    print('offset====$offset');
    print('width====${MediaQuery.of(context).size.width}');
    print('height====${MediaQuery.of(context).size.width/_controller.value.aspectRatio}');
    print('totalHeight====${MediaQuery.of(context).size.height}');
    print('aspectRatio====${_controller.value.aspectRatio}');

    _controller.setRect(Rect.fromLTWH(offset.dx, offset.dy, MediaQuery.of(context).size.width-offset.dx*2, MediaQuery.of(context).size.width/_controller.value.aspectRatio));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(padding: const EdgeInsets.only(top: 20.0)),
          const Text('With remote mp4'),
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(key: playerKey,_controller),
                  ClosedCaption(text: _controller.value.caption.text),
                  _ControlsOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayerVideoAndPopPage extends StatefulWidget {
  @override
  _PlayerVideoAndPopPageState createState() => _PlayerVideoAndPopPageState();
}

class _PlayerVideoAndPopPageState extends State<_PlayerVideoAndPopPage> {
  late VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.asset('assets/Butterfly-209.mp4');
    _videoPlayerController.addListener(() {
      if (startedPlaying && !_videoPlayerController.value.isPlaying) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<bool> started() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    startedPlaying = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: FutureBuilder<bool>(
          future: started(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data ?? false) {
              return AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              );
            } else {
              return const Text('waiting for video to load');
            }
          },
        ),
      ),
    );
  }
}

class MediaFlowVideoPage extends StatefulWidget {
  const MediaFlowVideoPage({Key? key}) : super(key: key);
  @override
  State<MediaFlowVideoPage> createState() => _MediaFlowVideoPageState();
}

class _MediaFlowVideoPageState extends State<MediaFlowVideoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          MediaVideoItem(key: ValueKey(0),url: "https://video-mediaxbase.testx.fzyun.cn/founder/mediax/media/202407/23/51c20d47e5896736432d481b.mp4",),
          MediaVideoItem(key: ValueKey(1),url: "https://video-mediaxbase.testx.fzyun.cn/founder/mediax/media/202504/03/51c23b4f81b69029dbf03bb3.mp4",),
          MediaVideoItem(key: ValueKey(2),url: "https://video-mediaxbase.testx.fzyun.cn/founder/mediax/media/202504/03/51c2134757af7494de92abd2.mp4",)
        ],
      ),
    );
  }
}

class MediaVideoItem extends StatefulWidget {
  final String url;
  const MediaVideoItem({Key? key,required this.url}) : super(key: key);

  @override
  State<MediaVideoItem> createState() => _MediaVideoItemState();
}

class _MediaVideoItemState extends State<MediaVideoItem> {

  late final VideoPlayerController _controller;

  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  GlobalKey playerKey = GlobalKey();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controller.dispose();
  }

  void init() async {
    try {

      // Create the controller
      _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.url),
          viewType: VideoViewType.textureView,
          videoPlayerOptions: VideoPlayerOptions(
              allowBackgroundPlayback: true,
          ),
          rect: Rect.fromLTWH(0, 200, 320, 100)
      );

      // Initialize the PipController
      // await _controller.initialize();


      print('_controller.value.aspectRatio===${_controller.value.aspectRatio}');

      // await _controller.play();

    } catch (e) {
      print(e);

    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();

    _controller.pause();
  }

  setup() async{
    await _controller.initialize();
    await _controller.play();

    final RenderBox? box = playerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      return;
    }
    final Offset offset = box.localToGlobal(Offset.zero);
    print('offset====$offset');
    print('width====${MediaQuery.of(context).size.width}');
    print('height====${MediaQuery.of(context).size.width/_controller.value.aspectRatio}');
    print('totalHeight====${MediaQuery.of(context).size.height}');

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: GestureDetector(
          onTap: (){
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          },
          child: Container(
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
              color: Colors.red,
              // Use [Video] widget to display video output.
              child: FutureBuilder(
                future: setup(),
                builder: (c,nap){
                  return AspectRatio(
                    key: playerKey,
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                },
              )
          ),
        ),
      ),
    );
  }
}