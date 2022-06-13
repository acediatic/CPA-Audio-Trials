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

  void updateTimeToPlay(int audioNumber) {
    updateFunction(int timeToPlay) => setState(() {
          _timeToPlay = timeToPlay;
        });

    _audioFileCollection.listenForTimeToPlay(audioNumber, updateFunction);
  }

  void getLoadTimes() async {
    if (isRunning) {
      return;
    }

    setState(() {
      isRunning = true;
    });

    _maxLoadTime = await _audioFileCollection.getMaxLoadTime();
    setState(() {
      _maxLoadTime;
      isRunning = false;
    });
  }

  void _regenerateAudioFileCollection() {
    setState(() {
      _audioFileCollection = AudioFileCollection.generate();
    });
  }

  List<Widget> getAudioButtons() {
    List<TextButton> buttons = [];
    for (int i = 0; i < _audioFileCollection.fileNames.length; i++) {
      buttons.add(TextButton(
        onPressed: () => updateTimeToPlay(i),
        child: Text((i + 1).toString()),
      ));
    }
    return buttons;
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
                  SizedBox(
                    height: 150,
                    width: 100,
                    // displays file name of all files in the collection
                    child: ListView.builder(
                        itemCount: _audioFileCollection.fileNames.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                              height: 20,
                              child:
                                  Text(_audioFileCollection.fileNames[index]));
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
            // displays a button per file in the collection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: getAudioButtons(),
            ),

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
