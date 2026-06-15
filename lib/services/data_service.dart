import '../../models/models.dart';

class DataService {
  static const List<Track> tracks = [
    Track(
      id: '1',
      title: 'Suru (feat. Stormzy)',
      artist: 'Asake',
      albumArt: 'assets/images/Asake.jpg',
      audioUrl: 'assets/audio/Asake_Ft_Stormzy_-_Suru.mp3',
      duration: Duration(minutes: 3, seconds: 12),
    ),
    Track(
      id: '2',
      title: 'Last Last',
      artist: 'Burna Boy',
      albumArt: 'assets/images/burnaboy.jpg',
      audioUrl: 'assets/audio/Burna_Boy-Last_Last-695a8e9429cb1.mp3',
      duration: Duration(minutes: 4, seconds: 1),
    ),
    Track(
      id: '3',
      title: 'Bend It',
      artist: 'Omah Lay',
      albumArt: 'assets/images/omalay.jpg',
      audioUrl: 'assets/audio/bend_you-Omah_Lay.mp3',
      duration: Duration(minutes: 3, seconds: 45),
    ),
    Track(
      id: '4',
      title: 'Joha',
      artist: 'Asake',
      albumArt: 'assets/images/Asake.jpg',
      audioUrl: 'assets/audio/Burna_Boy-Last_Last-695a8e9429cb1.mp3',
      duration: Duration(minutes: 2, seconds: 58),
    ),
    Track(
      id: '5',
      title: 'Declan Rice',
      artist: 'ODUMODUBLVCK',
      albumArt: 'assets/images/odumodu_black.jpg',
      audioUrl: 'assets/audio/bend_you-Omah_Lay.mp3',
      duration: Duration(minutes: 3, seconds: 22),
    ),
  ];

  static const List<RadioStation> radioStations = [
    RadioStation(
      id: '1',
      name: 'Burna Boy',
      coverImage: 'assets/images/burnaboy.jpg',
      color: '#FF6B5B',
      artists: 'Dave, Burna Boy, Jorja Smith, Shallipopi, Black ...',
    ),
    RadioStation(
      id: '2',
      name: 'OMAH LAY',
      coverImage: 'assets/images/omalay.jpg',
      color: '#9B8FD4',
      artists: 'OMAH LAY, Seyi Vibez, Olamide, Bella Shmurda...',
    ),
    RadioStation(
      id: '3',
      name: 'Asake',
      coverImage: 'assets/images/Asake.jpg',
      color: '#C8A96E',
      artists: 'Asake, Burna Boy, Sarz, Wizkid...',
    ),
  ];

  static const List<Album> albums = [
    Album(
      id: '1',
      title: 'Lungu Boy',
      artist: 'Asake',
      coverImage: 'assets/images/Asake.jpg',
    ),
    Album(
      id: '2',
      title: 'Mr. Money With The Vibe',
      artist: 'Asake',
      coverImage: 'assets/images/Asake.jpg',
    ),
    Album(
      id: '3',
      title: 'More Love, Less Ego',
      artist: 'Wizkid',
      coverImage: 'assets/images/wizkid.jpeg',
    ),
  ];

  static const List<Artist> popularArtists = [
    Artist(
      id: '1',
      name: 'ODUMODUBLVCK',
      imageUrl: 'assets/images/odumodu_black.jpg',
    ),
    Artist(id: '2', name: 'Asake', imageUrl: 'assets/images/Davido.jpg'),
    Artist(id: '3', name: 'Burna Boy', imageUrl: 'assets/images/patoranking.jpg'),
  ];

  static const List<Playlist> chillPlaylists = [
    Playlist(
      id: '1',
      title: 'Cocoa Butter',
      subtitle: '',
      coverImage: 'assets/images/burnaboy.jpg',
      artists: ['Don Toliver', 'Kendrick Lamar', 'Chris Brown', 'SZ...'],
    ),
    Playlist(
      id: '2',
      title: 'afro & soul',
      subtitle: '',
      coverImage: 'assets/images/omalay.jpg',
      artists: ['OMAH LAY', 'Ari Lennox', 'Kunmie', 'Strei', 'Amma'],
    ),
    Playlist(
      id: '3',
      title: 'Afrobeats Hits',
      subtitle: '',
      coverImage: 'assets/images/Asake.jpg',
      artists: ['Asake', 'Tunde', 'Rema', 'Davido...'],
    ),
  ];

  static Track get currentTrack => tracks[0];
}
