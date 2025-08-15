
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PlayingControls extends StatelessWidget {
  final bool isPlaying;
  final LoopMode? loopMode;
  final bool isPlaylist;
  final Function()? onPrevious;
  final Function() onPlay;
  final Function()? onNext;
  final Function()? toggleLoop;
  final Function()? onStop;

  const PlayingControls({super.key, 
    required this.isPlaying,
    this.isPlaylist = false,
    this.loopMode,
    this.toggleLoop,
    this.onPrevious,
    required this.onPlay,
    this.onNext,
    this.onStop,
  });

  // Widget _loopIcon(BuildContext context) {
  //   const iconSize = 34.0;
  //   if (loopMode == LoopMode.none) {
  //     return const Icon(
  //       Icons.loop,
  //       size: iconSize,
  //       color: Colors.grey,
  //     );
  //   } else if (loopMode == LoopMode.playlist) {
  //     return const Icon(
  //       Icons.loop,
  //       size: iconSize,
  //       color: Colors.black,
  //     );
  //   } else {
  //     //single
  //     return const Stack(
  //       alignment: Alignment.center,
  //       children: [
  //         Icon(
  //           Icons.loop,
  //           size: iconSize,
  //           color: Colors.black,
  //         ),
  //         Center(
  //           child: Text(
  //             '1',
  //             style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //       ],
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // GestureDetector(
          //   onTap: () {
          //     if (toggleLoop != null) toggleLoop!();
          //   },
          //   child: _loopIcon(context),
          // ),
          const SizedBox(
            width: 12,
          ),
          IconButton(
            onPressed: () {
              isPlaylist ? onPrevious : null;
            },
            icon: const Icon(Icons.skip_previous),
            iconSize: 50,
          ),
          const SizedBox(
            width: 12,
          ),
          IconButton(
            onPressed: onPlay,
            icon: Icon(
              isPlaying ? Icons.pause_sharp : Icons.play_arrow_sharp,
            ),
            iconSize: 50,
          ),
          const SizedBox(
            width: 12,
          ),
          IconButton(
            onPressed: () {
              isPlaylist ? onNext : null;
            },
            icon: const Icon(Icons.skip_next),
            iconSize: 50,
          ),
        ],
      ),
    );
  }
}
