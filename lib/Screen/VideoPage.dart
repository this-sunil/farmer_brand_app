import 'package:video_js_player/video_js_player.dart';
import 'package:flutter/material.dart';
class VideoPage extends StatelessWidget {
  final String url;
  const VideoPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    WebVideoPlayerController controller=WebVideoPlayerController();
    controller.load(WebPlayerSource.video(url, WebPlayerVideoSourceType.mp4));
    controller.play();
    return WebPlayer(
      controller: controller,
      controlsBuilder: (context,controller){
        return Stack(
          children: [
            Align(
              alignment: AlignmentGeometry.center,
              child: IconButton(onPressed: ()=>controller.value.isPaused?controller.play():controller.pause(), icon: CircleAvatar(
                child: Icon(controller.value.isPaused?Icons.play_arrow_rounded:Icons.pause),
              )),
            )
          ],
        );
      },
    );
  }
}
