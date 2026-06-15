import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/audio_player_service.dart';
import '../../services/data_service.dart';
import '../../widgets/mini_player.dart';
import '../../widgets/spotify_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayerService _playerService = AudioPlayerService();
  int _selectedFilter = 1; 
  int _selectedNav = 0; 

  static const List<String> _filters = [
    'All',
    'Music',
    'Following',
    'Podcasts',
  ];

  @override
  void dispose() {
    _playerService.dispose();
    super.dispose();
  }

  void _playTrack(Track track) {
    _playerService.playTrack(track);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildMadeForSection()),
                SliverToBoxAdapter(child: _buildPopularRadio()),
                SliverToBoxAdapter(child: _buildPopularAlbums()),
                SliverToBoxAdapter(child: _buildPopularArtists()),
                SliverToBoxAdapter(child: _buildSpotifyAndChill()),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
          ),
          // Mini player
          ListenableBuilder(
            listenable: _playerService,
            builder: (_, __) => MiniPlayer(playerService: _playerService),
          ),
          // Bottom navigation
          _buildBottomNav(),
        ],
      ),
    );
  }


  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF121212),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Row(
        children: [
          // Profile avatar
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF5856D6),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'L',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Filter chips
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // "All" standalone chip
                  GestureDetector(
                    onTap: () => setState(() => _selectedFilter = 0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedFilter == 0
                            ? const Color(0xFF1DB954)
                            : const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'All',
                        style: TextStyle(
                          color: _selectedFilter == 0
                              ? Colors.black
                              : Colors.white,
                          fontSize: 14,
                          fontWeight: _selectedFilter == 0
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF2A2A2A,
                      ), // same as standalone chips
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildToggleSegment(label: 'Music', index: 1),
                        _buildToggleSegment(label: 'Following', index: 2),
                      ],
                    ),
                  ),

                  // "Podcasts" standalone chip
                  GestureDetector(
                    onTap: () => setState(() => _selectedFilter = 3),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedFilter == 3
                            ? const Color(0xFF1DB954)
                            : const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Podcasts',
                        style: TextStyle(
                          color: _selectedFilter == 3
                              ? Colors.black
                              : Colors.white,
                          fontSize: 14,
                          fontWeight: _selectedFilter == 3
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSegment({required String label, required int index}) {
    final selected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF1DB954) // ← was Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.black
                : Colors.white, // ← was Colors.black : withOpacity(0.7)
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }


  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildMadeForSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Made For Linda'),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildDailyMixCard(
                label: 'Daily Mix 01',
                imagePath: 'assets/images/Asake.jpg',
                subtitle: 'Asake, Burna Boy, Sarz\nand more',
                onTap: () => _playTrack(DataService.tracks[0]),
              ),
              _buildDailyMixCard(
                label: 'Daily Mix 02',
                imagePath: 'assets/images/burnaboy.jpg',
                subtitle: 'Burna Boy, Wizkid, Fireboy\nand more',
                onTap: () => _playTrack(DataService.tracks[1]),
              ),
              _buildDailyMixCard(
                label: 'Daily Mix 03',
                imagePath: 'assets/images/omalay.jpg',
                subtitle: 'Omah Lay, Olamide, Naira\nand more',
                onTap: () => _playTrack(DataService.tracks[2]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyMixCard({
    required String label,
    required String imagePath,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SpotifyImage(
                  imagePath: imagePath,
                  width: 160,
                  height: 160,
                  borderRadius: BorderRadius.circular(6),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Image.asset(
                    'assets/images/spotify_icon.png',
                    width: 14,
                    height: 14,
                    errorBuilder: (_, __, ___) => Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'S',
                          style: TextStyle(
                            color: Color(0xFF1DB954),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(24, 237, 245, 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Daily Mix',
                          style: TextStyle(
                            color: Color.fromARGB(230, 5, 3, 3),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(24, 237, 245, 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          label.replaceAll('Daily Mix ', ''),
                          style: const TextStyle(
                            color: Color.fromARGB(230, 5, 3, 3),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Popular Radio 
  Widget _buildPopularRadio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Popular radio'),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: DataService.radioStations.length,
            itemBuilder: (_, i) {
              final station = DataService.radioStations[i];
              return GestureDetector(
                onTap: () => _playTrack(
                  DataService.tracks[i % DataService.tracks.length],
                ),
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRadioCard(station),
                      const SizedBox(height: 8),
                      Text(
                        station.artists,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRadioCard(RadioStation station) {
    Color bgColor = const Color(0xFFFF6B5B);
    try {
      final hex = station.color.replaceFirst('#', '');
      bgColor = Color(int.parse('FF$hex', radix: 16));
    } catch (_) {}

    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          // ── Logo (top-left) ──
          Positioned(
            top: 8,
            left: 8,
            child: Image.asset(
              'assets/images/spotify_icon.png',
              width: 14,
              height: 14,
              errorBuilder: (_, __, ___) => Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: Color(0xFF1DB954),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── "RADIO" text (top-right) ──
          const Positioned(
            top: 8,
            right: 8,
            child: Text(
              'RADIO',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),

          // Three overlapping artist circles ──
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: _buildArtistCircles(station.coverImage),
          ),

          // Station name 
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              station.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtistCircles(String mainImage) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: SpotifyImage(
                  imagePath: 'assets/images/2face.jpg',
                ),
              ),
            ),
          ),
          Positioned(
            left: 30,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipOval(child: SpotifyImage(imagePath: mainImage)),
            ),
          ),
          Positioned(
            left: 70,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: SpotifyImage(
                  imagePath: 'assets/images/kcee.jpg',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Popular Albums & Singles─

  Widget _buildPopularAlbums() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Popular albums and singles'),
        SizedBox(
          height: 210,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: DataService.albums.length,
            itemBuilder: (_, i) {
              final album = DataService.albums[i];
              return GestureDetector(
                onTap: () => _playTrack(
                  DataService.tracks[i % DataService.tracks.length],
                ),
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpotifyImage(
                        imagePath: album.coverImage,
                        width: 150,
                        height: 150,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        album.type,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        album.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        album.artist,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Popular Artists 

  Widget _buildPopularArtists() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Popular artists'),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: DataService.popularArtists.length,
            itemBuilder: (_, i) {
              final artist = DataService.popularArtists[i];
              return GestureDetector(
                onTap: () => _playTrack(
                  DataService.tracks[i % DataService.tracks.length],
                ),
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(
                          child: SpotifyImage(
                            imagePath: artist.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        artist.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Spotify & Chill 

  Widget _buildSpotifyAndChill() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Spotify & Chill'),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: DataService.chillPlaylists.length,
            itemBuilder: (_, i) {
              final playlist = DataService.chillPlaylists[i];
              return GestureDetector(
                onTap: () => _playTrack(
                  DataService.tracks[i % DataService.tracks.length],
                ),
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpotifyImage(
                        imagePath: playlist.coverImage,
                        width: 160,
                        height: 160,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        playlist.artists.take(4).join(', '),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //  Bottom Navigation 

  Widget _buildBottomNav() {
    final items = [
      (Icons.home_filled, Icons.home_outlined, 'Home'),
      (Icons.search, Icons.search, 'Search'),
      (Icons.library_music, Icons.library_music_outlined, 'Your Library'),
      (Icons.star, Icons.star_outline, 'Premium'),
      (Icons.add_box, Icons.add_box_outlined, 'Create'),
    ];

    return Container(
      color: const Color(0xFF000000),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 4,
        top: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final selected = _selectedNav == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedNav = i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? items[i].$1 : items[i].$2,
                  color: selected
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  size: 24,
                ),
                const SizedBox(height: 3),
                Text(
                  items[i].$3,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    fontSize: 10,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
