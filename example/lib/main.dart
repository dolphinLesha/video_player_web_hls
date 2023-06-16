import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(VideoApp());
}

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  Timer? _initTimer;
  bool needToReload = false;

  @override
  void initState() {
    super.initState();
    try {
      _controller = VideoPlayerController.network(
          '')
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
          _initTimer?.cancel();
          needToReload = false;
        });
      _controller.setVolume(0.0);
      _initTimer ??= Timer(const Duration(seconds: 3),(){
        setState(() {
          needToReload = true;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Stack(
          children: [
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
            !_controller.value.isInitialized ? Center(child: CircularProgressIndicator()) : const SizedBox(),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (needToReload)
            FloatingActionButton(
              onPressed: () async {
                // setState(() {
                //   _controller.value.isPlaying
                //       ? _controller.pause()
                //       : _controller.play();
                // });

                await _controller.dispose();
                _controller = VideoPlayerController.network(
                    '')
                  ..initialize().then((_) {
                    // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                    setState(() {});
                    _initTimer?.cancel();
                    needToReload = false;
                  });
                // _controller.initialize().then((_) {
                //   // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                //   setState(() {});
                //   _initTimer?.cancel();
                //   needToReload = false;
                // });
              },
              child: Icon(
                Icons.update,
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
