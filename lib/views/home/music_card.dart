import 'package:emodiary/database/entity.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicCard extends StatefulWidget {
  final Track track;
  final Function()? onTap;

  const MusicCard({super.key, required this.track, this.onTap});

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isPlaying = false;

  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    player.setUrl(widget.track.streamUrl);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(); // Default to spinning
    _controller.stop(); // Initially stop the rotation
  }

  @override
  void dispose() {
    player.dispose();
    _controller.dispose();
    super.dispose();
  }

  void handlePlayPause() {
    setState(() {
      if (player.playing) {
        player.pause();
        _controller.stop();
      } else {
        player.play();
        _controller.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3), // màu viền nhạt
          width: 1.5, // độ dày viền
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(-2, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Animated rotating image
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.141592653589793,
                child: child,
              );
            },
            child: ClipOval(
              child: Image.network(
                widget.track.thumbnailUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Song details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.track.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.track.artist,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: handlePlayPause,
                      icon: Icon(
                        player.playing ? Icons.pause_circle : Icons.play_circle,
                        size: 38,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onTap,
                      icon: Icon(
                        Icons.cancel_outlined,
                        size: 24,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
