import 'dart:io';

import 'package:cpa_demo_app/stopwatch.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const AudioSpeedTrialPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class AudioSpeedTrialPage extends StatefulWidget {
  const AudioSpeedTrialPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<AudioSpeedTrialPage> createState() => _AudioSpeedTrialPageState();
}

class _AudioSpeedTrialPageState extends State<AudioSpeedTrialPage> {
  static const maxRandomInt = 637;
  int randomNumber = 0;
  String saFileName = "";
  Stopwatch stopwatch = Stopwatch();
  bool isRunning = false;

  String formatNumber(int number) {
    return NumberFormat("000", 'en_US').format(number);
  }

  void updateRandomNumber() {
    setState(() {
      randomNumber = Random().nextInt(maxRandomInt);
      saFileName = formatNumber(randomNumber) + "SA.mp3";
    });
  }

  void startSearch() {
    stopwatch.reset();
    stopwatch.start();
    setState(() {
      isRunning = true;
    });
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
                  onPressed: () => {
                    startSearch(),
                    endSearch(),
                  },
                  child: const Text("Begin Search"),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isRunning ? Colors.yellow : Colors.transparent,
                  ),
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
                    "Audio file: " + saFileName,
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
