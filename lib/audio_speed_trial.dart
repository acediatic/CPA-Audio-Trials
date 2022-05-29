import 'package:cpa_demo_app/firebase_audio_files.dart';
import 'package:cpa_demo_app/stopwatch.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import "package:flutter/material.dart";
import 'show_error.dart';

class AudioSpeedTrialPage extends StatefulWidget {
  const AudioSpeedTrialPage({Key? key}) : super(key: key);
  @override
  State<AudioSpeedTrialPage> createState() => _AudioSpeedTrialPageState();
}

class _AudioSpeedTrialPageState extends State<AudioSpeedTrialPage> {
  static const maxRandomInt = 133;
  int randomNumber = 0;
  String saFileName = "";
  Stopwatch stopwatch = Stopwatch();
  bool isRunning = false;
  AudioPlayer audioPlayer = AudioPlayer();
  FirebaseAudio firebaseAudio = FirebaseAudio();

  String formatNumber(int number) {
    return NumberFormat("000", 'en_US').format(number);
  }

  void updateRandomNumber() {
    setState(() {
      randomNumber = Random().nextInt(maxRandomInt);
      saFileName = "${formatNumber(randomNumber)}SA.mp3";
    });
  }

  void startSearch() {
    stopwatch.reset();
    stopwatch.start();
    setState(() {
      isRunning = true;
    });

    firebaseAudio.getSAudioFromPath(saFileName).then((audioUrl) {
      return audioPlayer.play(audioUrl);
    }).catchError((e) {
      showError(context, e.toString());
    }).whenComplete(endSearch);
  }

  void endSearch() {
    stopwatch.stop();
    setState(() {
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("Source:", style: Theme.of(context).textTheme.headline2),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                      onPressed: updateRandomNumber,
                      child: const Text("Generate Random Number")),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: Text(formatNumber(randomNumber)),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: startSearch,
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isRunning ? Colors.yellow : Colors.transparent,
                  ),
                  child: const Text("Begin Search"),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: SearchStopwatch(time: stopwatch.elapsedMilliseconds),
                ),
              ],
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    "Audio file: $saFileName",
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
