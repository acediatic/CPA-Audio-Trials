import 'dart:math';
import 'package:cpa_demo_app/firebase_audio_files.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

class AudioFile {
  static const maxRandomInt = 133;
  final int _randomNumber = Random().nextInt(maxRandomInt);
  final AudioPlayer audioPlayer = AudioPlayer();

  late final String downloadURL;

  AudioFile() {
    _setdownloadUrl();
  }

  void _setdownloadUrl() {
    FirebaseAudio().getSAudioFromPath(fileName).then((url) {
      downloadURL = url;
    });
  }

  String get fileName => "${_formatNumber(_randomNumber)}SA.mp3";

  String _formatNumber(int number) {
    return NumberFormat("000", 'en_US').format(number);
  }

  // `true` if the `load()` action has been completed and an audio is currently
  // `loaded` in the audioPlayer
  bool get loaded =>
      audioPlayer.processingState == ProcessingState.ready ||
      audioPlayer.processingState == ProcessingState.completed ||
      audioPlayer.processingState == ProcessingState.buffering;
}
