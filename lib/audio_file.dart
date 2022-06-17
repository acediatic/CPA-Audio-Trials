import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:cpa_demo_app/firebase_audio_files.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class AudioFile {
  static const maxRandomInt = 637 - 150;
  final int _randomNumber = Random().nextInt(maxRandomInt) + 150;
  final AudioPlayer audioPlayer = AudioPlayer();
  String downloadURL = "";
  Stopwatch stopwatch = Stopwatch();
  int _loadTime = 0;
  int _timeToPlay = 0;
  Uint8List audioBytes = Uint8List(0);

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

  Future<Uint8List> get audioData async {
    if (audioBytes.lengthInBytes == 0) {
      http.Client client = http.Client();
      http.Response response = await client.get(Uri.parse(downloadURL));
      if (response.statusCode == 200) {
        audioBytes = response.bodyBytes;
      } else {
        throw Exception("Unable to fetch audio data");
      }
    }

    return audioBytes;
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

    await audioData;

    stopwatch.stop();
    _loadTime = stopwatch.elapsedMicroseconds;
    return _loadTime;
  }

  Future<int> timeToPlay() async {
    if (_timeToPlay == 0) {
      if (_loadTime == 0) {
        await _timeLoadAudio();
      }

      if (audioBytes.lengthInBytes == 0) {
        await audioData;
      }

      await audioPlayer.stop();

      stopwatch.stop();
      stopwatch.reset();
      stopwatch.start();

      await audioPlayer.play(BytesSource(audioBytes));

      stopwatch.stop();
      _timeToPlay = stopwatch.elapsedMicroseconds;
    } else {
      await audioPlayer.stop();
      await audioPlayer.resume();
    }
    return _timeToPlay;
  }

  Future<void> playAudio() {
    return audioPlayer.resume();
  }

  Future<void> stopAudio() {
    return audioPlayer.stop();
  }

  String get fileName => "${_formatNumber(_randomNumber)}SA.mp3";

  String _formatNumber(int number) {
    return NumberFormat("000", 'en_US').format(number);
  }
}
