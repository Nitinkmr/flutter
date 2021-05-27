import 'package:flutter/material.dart';
//import 'package:video_app/pages/MyLiveStream.dart';
import 'package:video_app/pages/UserList.dart';
import 'package:video_player/video_player.dart';


void main() => runApp(MaterialApp(

  routes: {
    '/' : (context) => MyLiveStream(),
    '/video': (context) => UserList()
  },
));

// class VideoApp extends StatefulWidget {
//   @override
//   _VideoAppState createState() => _VideoAppState();
// }

class MyLiveStream extends StatefulWidget {

  @override
  _MyLiveStreamState createState() => _MyLiveStreamState();
}

class _MyLiveStreamState extends State<MyLiveStream> {
  late VideoPlayerController _controller;
  int duration = 200;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().
      then((_) {
        _controller.play();
      });
    _controller.addListener(() {

      if (!_controller.value.isPlaying &&
          _controller.value.position.inSeconds >=
              _controller.value.duration.inSeconds) {
        // completion
        print('videoPlayer completion');

        Future.delayed(Duration(milliseconds: duration),(){
          duration = duration*2;
          _controller.seekTo(const Duration(seconds: 0));
        });


      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
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
