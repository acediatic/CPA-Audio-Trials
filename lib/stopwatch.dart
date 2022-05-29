import 'package:flutter/material.dart';

class SearchStopwatch extends StatelessWidget {
  const SearchStopwatch({Key? key, required this.time}) : super(key: key);
  final int time;

  @override
  Widget build(BuildContext context) {
    return Text("${time}ms");
  }
}
