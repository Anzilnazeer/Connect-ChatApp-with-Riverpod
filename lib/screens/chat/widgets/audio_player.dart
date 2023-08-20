import 'package:connect_riverpod/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final Color? activeColor;
  const AudioPlayerWidget({required this.audioUrl, required this.activeColor});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
        _sliderValue = _position.inMilliseconds.toDouble();
      });
    });
    _audioPlayer.setSource(UrlSource(widget.audioUrl));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _seekTo(double value) {
    Duration seekPosition = Duration(milliseconds: value.toInt());
    _audioPlayer.seek(seekPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Slider(
          activeColor: widget.activeColor,
          thumbColor: scafoldcolor,
          value: _sliderValue,
          onChanged: (value) => _seekTo(value),
          min: 0,
          max: _duration.inMilliseconds.toDouble(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _playPause,
              child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "${_position.inMinutes}:${_position.inSeconds.remainder(60)}",
              style: const TextStyle(color: Color.fromARGB(255, 103, 103, 103)),
            ),
          ],
        ),
      ],
    );
  }
}
