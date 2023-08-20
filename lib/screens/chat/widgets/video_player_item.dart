import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String viedoUrl;
  const VideoPlayerItem({super.key, required this.viedoUrl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController controller;
  bool isPlaying = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CachedVideoPlayerController.network(widget.viedoUrl)
      ..initialize().then((value) {
        controller.setVolume(1);
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(controller),
          Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  if (isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                },
                icon: Icon(!isPlaying ? Icons.play_circle : Icons.pause_circle),
              ))
        ],
      ),
    );
  }
}
