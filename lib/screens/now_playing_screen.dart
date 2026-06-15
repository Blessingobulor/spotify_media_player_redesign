import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../services/audio_player_service.dart';
import '../services/data_service.dart';
import '../models/models.dart';

class NowPlayingScreen extends StatefulWidget {
  final AudioPlayerService playerService;

  const NowPlayingScreen({super.key, required this.playerService});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool _isShuffled = false;
  bool _isLiked = false;

  // Dark olive green matching the reference image background
  static const Color _bgColor = Color(0xFF2D3B1F);
  static const Color _bgDark = Color(0xFF1A1A1A);

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final track = widget.playerService.currentTrack;
    final tracks = DataService.tracks;

    return Scaffold(
      backgroundColor: _bgDark,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // ── Hero section with olive background ──
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_bgColor, _bgDark],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Back arrow ──
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 4, bottom: 0),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white, size: 26),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),

                          // ── Album art ──
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            child: ListenableBuilder(
                              listenable: widget.playerService,
                              builder: (_, __) {
                                final currentTrack =
                                    widget.playerService.currentTrack;
                                return AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black.withValues(alpha: 0.5),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        // Artist image
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Image.asset(
                                            currentTrack.albumArt,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: const Color(0xFF2A2A2A),
                                              ),
                                              child: const Icon(
                                                  Icons.music_note,
                                                  color: Colors.white54,
                                                  size: 80),
                                            ),
                                          ),
                                        ),
                                        // Spotify icon top-left
                                        Positioned(
                                          top: 12,
                                          left: 12,
                                          child: Image.asset(
                                            'assets/images/spotify_icon.png',
                                            width: 28,
                                            height: 28,
                                            // color: const Color(0xFF1DB954),
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                              width: 28,
                                              height: 28,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF1DB954),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: Text('S',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Bottom badges: Daily Mix + 01
                                        Positioned(
                                          bottom: 16,
                                          left: 12,
                                          right: 12,
                                          child: Row(
                                            children: [
                                              // Daily Mix badge
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                                color: const Color(0xFF00FFFF),
                                                child: const Text(
                                                  'Daily Mix',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              // Number badge
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                                color: const Color(0xFF00FFFF),
                                                child: const Text(
                                                  'O1',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // ── Artists subtitle ──
                          const Padding(
                            padding: EdgeInsets.fromLTRB(24, 12, 24, 4),
                            child: Text(
                              'Asake, Burna Boy, Sarz and more',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          // ── Made for you row ──
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/spotify_icon.png',
                                  width: 28,
                                  height: 28,
                                  // color: const Color(0xFF1DB954),
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.circle,
                                      color: Color(0xFF1DB954),
                                      size: 28),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Made for you',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ── About line ──
                          Padding(
                            padding: EdgeInsets.fromLTRB(24, 6, 24, 2),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'About ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'recommendations and the impact of promotion',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ── Duration ──
                          const Padding(
                            padding: EdgeInsets.fromLTRB(24, 4, 24, 12),
                            child: Text(
                              '2h 36min',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ),

                          // ── Action bar ──
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            child: Row(
                              children: [
                                // Small album art thumbnail
                                ListenableBuilder(
                                  listenable: widget.playerService,
                                  builder: (_, __) => ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.asset(
                                      widget.playerService.currentTrack
                                          .albumArt,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 44,
                                        height: 44,
                                        color: const Color(0xFF2A2A2A),
                                        child: const Icon(Icons.music_note,
                                            color: Colors.white54, size: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Add
                                _actionIcon(Icons.add_circle_outline),
                                const SizedBox(width: 4),
                                // Download
                                _actionIcon(Icons.download_outlined),
                                const SizedBox(width: 4),
                                // More
                                _actionIcon(Icons.more_vert),
                                const Spacer(),
                                // Shuffle
                                IconButton(
                                  icon: Icon(
                                    Icons.shuffle,
                                    color: _isShuffled
                                        ? const Color(0xFF1DB954)
                                        : Colors.white60,
                                    size: 26,
                                  ),
                                  onPressed: () =>
                                      setState(() => _isShuffled = !_isShuffled),
                                ),
                                // Big green play button
                                StreamBuilder<PlayerState>(
                                  stream:
                                      widget.playerService.playerStateStream,
                                  builder: (context, snapshot) {
                                    final isPlaying =
                                        snapshot.data?.playing ?? false;
                                    final isLoading =
                                        widget.playerService.isLoading;
                                    return GestureDetector(
                                      onTap:
                                          widget.playerService.togglePlayPause,
                                      child: Container(
                                        width: 56,
                                        height: 56,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF1DB954),
                                          shape: BoxShape.circle,
                                        ),
                                        child: isLoading
                                            ? const Padding(
                                                padding: EdgeInsets.all(14),
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.5,
                                                ),
                                              )
                                            : Icon(
                                                isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                color: Colors.white,
                                                size: 32,
                                              ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Track list ──
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final t = tracks[i];
                      return _buildTrackRow(t, i);
                    },
                    childCount: tracks.length,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
          ),

          // ── Mini player at bottom ──
          _buildMiniPlayer(track),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon) {
    return IconButton(
      icon: Icon(icon, color: Colors.white60, size: 26),
      onPressed: () {},
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }

  Widget _buildTrackRow(Track t, int index) {
    return ListenableBuilder(
      listenable: widget.playerService,
      builder: (_, __) {
        final isCurrent = widget.playerService.currentTrack.id == t.id;
        return InkWell(
          onTap: () => widget.playerService.playTrack(t),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                // Album art
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    t.albumArt,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 56,
                      height: 56,
                      color: const Color(0xFF2A2A2A),
                      child: const Icon(Icons.music_note,
                          color: Colors.white54, size: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Title + artist
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Currently playing shows green + "..." prefix
                      RichText(
                        text: TextSpan(
                          children: [
                            if (isCurrent)
                              const TextSpan(
                                text: '... ',
                                style: TextStyle(
                                  color: Color(0xFF1DB954),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            TextSpan(
                              text: t.title,
                              style: TextStyle(
                                color: isCurrent
                                    ? const Color(0xFF1DB954)
                                    : Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.artist,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // More icon
                IconButton(
                  icon: Icon(Icons.more_vert,
                      color: Colors.white.withValues(alpha: 0.6), size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniPlayer(Track track) {
    return ListenableBuilder(
      listenable: widget.playerService,
      builder: (_, __) {
        final currentTrack = widget.playerService.currentTrack;
        return StreamBuilder<PlayerState>(
          stream: widget.playerService.playerStateStream,
          builder: (context, snapshot) {
            final isPlaying = snapshot.data?.playing ?? false;
            return Container(
              margin: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              height: 68,
              decoration: BoxDecoration(
                // Reddish tint matching the reference mini player
                color: const Color(0xFF8B2020),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  // Album art
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      currentTrack.albumArt,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 50,
                        height: 50,
                        color: const Color(0xFF2A2A2A),
                        child: const Icon(Icons.music_note,
                            color: Colors.white54, size: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Track info
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentTrack.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          currentTrack.artist,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Device icon
                  IconButton(
                    icon: const Icon(Icons.devices,
                        color: Colors.white, size: 22),
                    onPressed: () {},
                  ),
                  // Add / plus circle
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(Icons.add,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 4),
                  // Play / pause
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: widget.playerService.togglePlayPause,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}