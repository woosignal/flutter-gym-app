//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:video_player/video_player.dart';

class VideoBackgroundPlayerWidget extends StatefulWidget {
  VideoBackgroundPlayerWidget({super.key, this.color, this.opacity = 0.5});

  final Color? color;
  final double opacity;

  @override
  State<VideoBackgroundPlayerWidget> createState() =>
      _VideoBackgroundPlayerWidgetState();
}

class _VideoBackgroundPlayerWidgetState
    extends NyState<VideoBackgroundPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  boot() async {
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(getEnv('APP_HERO_VIDEO')));
    await _controller.initialize();
    await _controller.setVolume(0.0);
    await _controller.setLooping(true);
    await _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return afterLoad(
      child: () => Container(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: Opacity(
              opacity: widget.opacity,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
      ).animate().fadeIn(duration: Duration(seconds: 1)),
      loading: Platform.isAndroid
          ? CircularProgressIndicator()
          : CupertinoActivityIndicator(),
    );
  }
}
