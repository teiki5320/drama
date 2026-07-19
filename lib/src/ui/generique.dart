import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// La récompense de fin d'épisode : un court générique vidéo.
class GeneriquePage extends StatefulWidget {
  const GeneriquePage({super.key, required this.asset, required this.title});

  final String asset;
  final String title;

  @override
  State<GeneriquePage> createState() => _GeneriquePageState();
}

class _GeneriquePageState extends State<GeneriquePage> {
  late final VideoPlayerController _controller;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.asset)
      ..addListener(_onTick)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller.play();
      });
  }

  void _onTick() {
    final v = _controller.value;
    if (!_closing &&
        v.isInitialized &&
        v.duration > Duration.zero &&
        v.position >= v.duration) {
      _closing = true;
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = _controller.value;
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: v.isInitialized
                      ? AspectRatio(
                          aspectRatio: v.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.white38),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 18,
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.4,
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon:
                      const Icon(Icons.close, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
