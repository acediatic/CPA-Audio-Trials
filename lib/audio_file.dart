import 'dart:math';
import 'package:cpa_demo_app/firebase_audio_files.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

class AudioFile {
  static const maxRandomInt = 133;
  final int _randomNumber = Random().nextInt(maxRandomInt);
  final AudioPlayer audioPlayer = AudioPlayer();
  String downloadURL = "";
  Stopwatch stopwatch = Stopwatch();
  int _loadTime = 0;

  AudioFile() {
    _setdownloadUrl();
  }

  Future<void> _setdownloadUrl() async {
    downloadURL = await FirebaseAudio().getSAudioFromPath(fileName);
  }

  int get loadTime {
    if (_loadTime == 0) {
      _timeLoadAudio();
    }
    return _loadTime;
  }

  Future<int> _timeLoadAudio() async {
    if (downloadURL.isEmpty) {
      await _setdownloadUrl();
    }

    stopwatch.reset();
    stopwatch.start();

    // technically the time taken to get full duration, but a proxy for loading time
    await audioPlayer.setUrl(downloadURL, preload: true);
    stopwatch.stop();
    _loadTime = stopwatch.elapsedMicroseconds;

    print("Is loaded: $_loaded");
    return loadTime;
  }

  String get fileName => "${_formatNumber(_randomNumber)}SA.mp3";

  String _formatNumber(int number) {
    return NumberFormat("000", 'en_US').format(number);
  }

  // `true` if the `load()` action has been completed and an audio is currently
  // `loaded` in the audioPlayer
  bool get _loaded =>
      audioPlayer.processingState == ProcessingState.ready ||
      audioPlayer.processingState == ProcessingState.completed ||
      audioPlayer.processingState == ProcessingState.buffering;
}
