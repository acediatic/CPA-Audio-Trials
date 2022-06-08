import 'package:cpa_demo_app/firebase_audio_files.dart';
import 'package:cpa_demo_app/stopwatch.dart';
import 'package:audioplayers/audioplayers.dart';
import "package:flutter/material.dart";
import 'show_error.dart';
import 'package:collection/collection.dart';

class AudioSpeedTrialPage extends StatefulWidget {
  const AudioSpeedTrialPage({Key? key}) : super(key: key);
  @override
  State<AudioSpeedTrialPage> createState() => _AudioSpeedTrialPageState();
}

class _AudioSpeedTrialPageState extends State<AudioSpeedTrialPage> {
  static AudioCache localAudioCache = AudioCache(prefix: "assets/audio/S/");

  int randomNumber = 0;
  String saFileName = "";
  Stopwatch stopwatch = Stopwatch();
  bool isRunning = false;
  AudioPlayer audioPlayer = AudioPlayer();
  FirebaseAudio firebaseAudio = FirebaseAudio();
  List<int> log = [];
  bool useFirebase = false;

  void playFromFirebase() async {
    print("playFromFirebase");
    String audioURL =
        await firebaseAudio.getSAudioFromPath(saFileName).catchError((e) {
      showError(context, e.toString());
    });
    log.add(stopwatch.elapsedMicroseconds);
    audioPlayer.play(audioURL);
    endSearch();
  }

  void playFromLocal() async {
    print("playFromLocal");
    log.add(stopwatch.elapsedMicroseconds);
    audioPlayer = await localAudioCache.play(saFileName);
    endSearch();
  }

  void startSearch() {
    audioPlayer.stop();
    stopwatch.reset();
    stopwatch.start();
    setState(() {
      isRunning = true;
    });

    useFirebase ? playFromFirebase() : playFromLocal();
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
            Row(
              children: [
                Text("Source:", style: Theme.of(context).textTheme.headline4),
                ToggleButtons(
                  isSelected: [!useFirebase, useFirebase],
                  onPressed: (int index) {
                    setState(() {
                      log = [];
                      useFirebase = index == 1;
                    });
                  },
                  children: const <Widget>[
                    Icon(Icons.phone_android),
                    Icon(Icons.computer)
                  ],
                ),
              ],
            ),
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
                  child: SearchStopwatch(
                      time: log.isNotEmpty ? log[log.length - 1] : 0),
                ),
              ],
            ),
            Text(
                "Average over ${log.length} runs: ${log.isNotEmpty ? "${(log.sum / log.length).toStringAsFixed(2)}μs" : "N/A"}"),
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
