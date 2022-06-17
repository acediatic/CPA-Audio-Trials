import 'package:cpa_demo_app/audio_file.dart';
import 'dart:math';

class AudioFileCollection {
  final List<AudioFile> _audioFiles = [];
  Stopwatch playbackStopwatch = Stopwatch();

  AudioFileCollection.generate() {
    for (int i = 0; i < 5; i++) {
      _audioFiles.add(AudioFile());
    }
  }

  Future<int> timeToPlay(int audioIndex) async {
    // stop all audio players
    for (var audioFile in _audioFiles) {
      await audioFile.stopAudio();
    }

    return _audioFiles[audioIndex].timeToPlay();
  }

  List<String> get fileNames {
    return _audioFiles.map((audioFile) => audioFile.fileName).toList();
  }

  Future<List<int>> getLoadTimes() async {
    List<Future<int>> loadTimeFutures = [];
    for (int i = 0; i < _audioFiles.length; i++) {
      loadTimeFutures.add(_audioFiles[i].loadTime);
    }

    return await Future.wait(loadTimeFutures);
  }

  Future<int> getMaxLoadTime() async {
    List<int> loadTimes = await getLoadTimes();

    if (loadTimes.isEmpty) {
      throw Exception("No load times");
    }

    return loadTimes.reduce(max);
  }

  void playAudioNumber(int number) async {
    if (number < 0 || number >= _audioFiles.length) {
      throw Exception("Invalid number");
    }

    for (int i = 0; i < _audioFiles.length; i++) {
      if (i == number) {
        _audioFiles[i].playAudio();
      } else {
        _audioFiles[i].stopAudio();
      }
    }
  }
}
