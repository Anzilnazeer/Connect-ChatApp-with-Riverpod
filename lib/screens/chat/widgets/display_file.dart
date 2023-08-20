import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_riverpod/screens/chat/widgets/audio_player.dart';
import 'package:connect_riverpod/screens/chat/widgets/video_player_item.dart';
import 'package:connect_riverpod/utils/common/enums/message_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DisplayFile extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final Color? color;
  final Color? activeColor;
  const DisplayFile(
      {super.key, required this.message, required this.type, this.color, this.activeColor});

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: TextStyle(color: color ?? Colors.white, fontSize: 15),
          )
        : type == MessageEnum.audio
            ? SizedBox(
                height: 35.h,
                child: AudioPlayerWidget(audioUrl: message,activeColor: activeColor,),
              )
            : type == MessageEnum.video
                ? VideoPlayerItem(viedoUrl: message)
                : CachedNetworkImage(imageUrl: message);
  }
}
