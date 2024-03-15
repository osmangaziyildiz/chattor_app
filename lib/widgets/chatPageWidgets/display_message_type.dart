import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattor_app/constants/screen_size.dart';
import 'package:chattor_app/enums/message_enum.dart';
import 'package:chattor_app/widgets/chatPageWidgets/video_player_item.dart';
import 'package:flutter/material.dart';

class DisplayMessageType extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final Color textColor;
  const DisplayMessageType(
      {super.key,
      required this.message,
      required this.type,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final audioPlayer = AudioPlayer();
    return type == MessageEnum.audio
        ? StatefulBuilder(builder: (context, setState) {
            return IconButton(
              constraints:
                  BoxConstraints(minWidth: ScreenSize.getWidth(context) * 0.5),
              onPressed: () async {
                if (isPlaying) {
                  await audioPlayer.pause();
                  setState(() {
                    isPlaying = false;
                  });
                } else {
                  await audioPlayer.play(UrlSource(message));
                  setState(() {
                    isPlaying = true;
                  });
                }
              },
              icon: Icon(isPlaying ? Icons.pause : Icons.play_circle),
            );
          })
        : type == MessageEnum.text
            ? Text(
                message,
                style: TextStyle(color: textColor),
              )
            : type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: message)
                : CachedNetworkImage(imageUrl: message);
  }
}
