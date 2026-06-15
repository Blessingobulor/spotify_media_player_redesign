import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../../models/models.dart';
import '../../services/data_service.dart';

class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  Track _currentTrack = DataService.currentTrack;
  bool _isLoading = false;
  String? _error;

  Track get currentTrack => _currentTrack;
  bool get isPlaying => _player.playing;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Duration get position => _player.position;
  Duration? get duration => _player.duration;
  double get volume => _player.volume;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  AudioPlayerService() {
    _player.playerStateStream.listen((_) => notifyListeners());
    _player.positionStream.listen((_) => notifyListeners());
  }

  Future<void> playTrack(Track track) async {
    _currentTrack = track;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _player.stop();
      if (track.audioUrl.startsWith('assets/')) {
        await _player.setAsset(track.audioUrl); // ← key change
      } else {
        await _player.setUrl(track.audioUrl);
      }
      await _player.play();
    } catch (e) {
      _error = 'Could not play track';
      debugPrint('Audio error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      if (_player.processingState == ProcessingState.idle ||
          _player.processingState == ProcessingState.completed) {
        // Reload asset correctly on resume
        if (_currentTrack.audioUrl.startsWith('assets/')) {
          await _player.setAsset(_currentTrack.audioUrl);
        } else {
          await _player.setUrl(_currentTrack.audioUrl);
        }
      }
      await _player.play();
    }
    notifyListeners();
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  Future<void> skipNext() async {
    final tracks = DataService.tracks;
    final currentIndex = tracks.indexWhere((t) => t.id == _currentTrack.id);
    final nextIndex = (currentIndex + 1) % tracks.length;
    await playTrack(tracks[nextIndex]);
  }

  Future<void> skipPrevious() async {
    if (_player.position.inSeconds > 3) {
      await _player.seek(Duration.zero);
      return;
    }
    final tracks = DataService.tracks;
    final currentIndex = tracks.indexWhere((t) => t.id == _currentTrack.id);
    final prevIndex = (currentIndex - 1 + tracks.length) % tracks.length;
    await playTrack(tracks[prevIndex]);
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
