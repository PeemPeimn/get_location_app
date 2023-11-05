// import 'dart:developer';
import 'dart:async';

import 'package:format/format.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_location_app/models/coordinates.dart';

class RecordScreen extends StatefulWidget {
  final int seconds;

  const RecordScreen({
    super.key,
    required this.seconds,
  });

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List<Coordinates> positionList = [];
  bool isStopped = false;
  int secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    getPositionList();
  }

  void getPositionList() async {
    var seconds = Duration(seconds: widget.seconds);
    Timer.periodic(seconds, (Timer t) {
      if (isStopped) {
        t.cancel();
      } else {
        getPosition();
      }
    });
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          secondsElapsed += 1;
        });
      }
    });
  }

  void getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    positionList.add(Coordinates(position.latitude, position.longitude));
    // log("latitude ${position.latitude}, longitude ${position.longitude}");
    // log(positionList.toString());
  }

  String secondsToClockString(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds % 60;

    return '{:02d}:{:02d}'.format(min, sec);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              secondsToClockString(secondsElapsed),
              style: const TextStyle(fontSize: 32),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  isStopped = true;
                  Navigator.pop(context, positionList);
                },
                child: const Text("Stop")),
          ),
        ],
      )),
    );
  }
}
