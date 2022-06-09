import 'package:cpa_demo_app/audio_file_collection.dart';
import "package:flutter/material.dart";
import 'show_error.dart';

class AudioSpeedTrialPage extends StatefulWidget {
  const AudioSpeedTrialPage({Key? key}) : super(key: key);
  @override
  State<AudioSpeedTrialPage> createState() => _AudioSpeedTrialPageState();
}

class _AudioSpeedTrialPageState extends State<AudioSpeedTrialPage> {
  AudioFileCollection _audioFileCollection = AudioFileCollection.generate();

  bool isRunning = false;
  int _maxLoadTime = 0;
  int _timeToPlay = 0;

  void updateTimeToPlay() {
    updateFunction(int timeToPlay) => setState(() {
          _timeToPlay = timeToPlay;
        });

    _audioFileCollection.listenForTimeToPlay(0, updateFunction);
  }

  void getLoadTimes() {
    setState(() {
      isRunning = true;
    });

    setState(() async {
      _maxLoadTime = await _audioFileCollection.getMaxLoadTime();
      isRunning = false;
    });
  }

  void _regenerateAudioFileCollection() {
    setState(() {
      _audioFileCollection = AudioFileCollection.generate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("Source: Server",
                style: Theme.of(context).textTheme.headline4),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                      onPressed: _regenerateAudioFileCollection,
                      child: const Text("R#")),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    // displays file name of all files in the collection
                    child: ListView.builder(
                        itemCount: _audioFileCollection.fileNames.length,
                        itemBuilder: (context, index) {
                          return Text(_audioFileCollection.fileNames[index]);
                        }),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: getLoadTimes,
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isRunning ? Colors.yellow : Colors.transparent,
                  ),
                  child: const Text("Re"),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                      "Max Load Times: ${(_maxLoadTime / 1000).toStringAsFixed(2)}ms"),
                ),
              ],
            ),
            // displays box with time to play audio file
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                  "Time to play: ${_timeToPlay.toStringAsFixed(2)} micro seconds."),
            ),
          ],
        ),
      ),
    );
  }
}
