import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../services/audio_player_service.dart';
import '../../widgets/spotify_image.dart';
import '../screens/now_playing_screen.dart'; 

class MiniPlayer extends StatelessWidget {
  final AudioPlayerService playerService;

  const MiniPlayer({super.key, required this.playerService});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) =>
                NowPlayingScreen(playerService: playerService),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF282828),
          borderRadius: BorderRadius.circular(10),
        ),
        child: StreamBuilder<PlayerState>(
          stream: playerService.playerStateStream,
          builder: (context, snapshot) {
            final isPlaying = snapshot.data?.playing ?? false;
            final track = playerService.currentTrack;

            return Row(
              children: [
                const SizedBox(width: 8),
                // Album art
                SpotifyImage(
                  imagePath: track.albumArt,
                  width: 48,
                  height: 48,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(width: 12),
                // Track info
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        track.artist,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7), // ← fixed
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Connect to device icon
                IconButton(
                  icon: const Icon(
                    Icons.devices,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {},
                ),
                // Saved / check circle
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1DB954),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 4),
                // Play / pause
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: playerService.togglePlayPause,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
