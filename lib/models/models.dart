class Track {
  final String id;
  final String title;
  final String artist;
  final String albumArt; // asset path or network URL
  final String audioUrl;
  final Duration duration;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.audioUrl,
    this.duration = const Duration(minutes: 3, seconds: 30),
  });
}

class Playlist {
  final String id;
  final String title;
  final String subtitle;
  final String coverImage;
  final List<String> artists;

  const Playlist({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.coverImage,
    required this.artists,
  });
}

class Album {
  final String id;
  final String title;
  final String artist;
  final String coverImage;
  final String type; // Album, Single, EP

  const Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverImage,
    this.type = 'Album',
  });
}

class Artist {
  final String id;
  final String name;
  final String imageUrl;

  const Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class RadioStation {
  final String id;
  final String name;
  final String coverImage;
  final String color;
  final String artists;

  const RadioStation({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.color,
    required this.artists,
  });
}