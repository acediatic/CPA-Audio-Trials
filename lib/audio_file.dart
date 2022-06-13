import 'dart:async';
import 'dart:math';
import 'package:cpa_demo_app/firebase_audio_files.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

class AudioFile {
  static const maxRandomInt = 637 - 150;
  final int _randomNumber = Random().nextInt(maxRandomInt) + 150;
  final AudioPlayer audioPlayer = AudioPlayer();
  String downloadURL = "";
  Stopwatch stopwatch = Stopwatch();
  int _loadTime = 0;
  int _timeToPlay = 0;

  AudioFile() {
    _setdownloadUrl();
  }

  Future<void> _setdownloadUrl() async {
    try {
      downloadURL = await FirebaseAudio().getSAudioFromPath(fileName);
    } catch (e) {
      print("Unable to fetch downloadUrl for $fileName");
      print("error: " + e.toString());
    }
  }

  Future<int> get loadTime {
    return _timeLoadAudio();
  }

  Future<int> _timeLoadAudio() async {
    if (downloadURL.isEmpty) {
      await _setdownloadUrl();
      if (downloadURL.isEmpty) {
        return 0;
      }
    }

    stopwatch.reset();
    stopwatch.start();

    // technically the time taken to get full duration, but a proxy for loading time
    await audioPlayer.setUrl(downloadURL, preload: true);
    stopwatch.stop();
    _loadTime = stopwatch.elapsedMicroseconds;
    return _loadTime;
  }

  void timeToPlay(Function notificationFn) async {
    if (_loadTime == 0) {
      await _timeLoadAudio();
    }

    bool hasNotified = false;

    void playAudioListener(PlayerState state) {
      bool readyToPlay = !hasNotified &&
          state.playing &&
          state.processingState == ProcessingState.ready;

      if (readyToPlay) {
        stopwatch.stop();
        _timeToPlay = stopwatch.elapsedMicroseconds;
        notificationFn(_timeToPlay);
        hasNotified = true;
      }

      if (state.processingState == ProcessingState.completed) {
        audioPlayer.stop();
      }
    }

    audioPlayer.playerStateStream.listen(playAudioListener);
    stopwatch.stop();
    stopwatch.reset();
    stopwatch.start();

    playAudio();
  }

  Future<void> playAudio() {
    return audioPlayer.play();
  }

  Future<void> stopAudio() {
    return audioPlayer.stop();
  }

  void addProcessingStateListener(Function(PlayerState) function) {
    audioPlayer.playerStateStream.listen(function);
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
