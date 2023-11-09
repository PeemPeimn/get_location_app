import 'dart:async';
import 'dart:developer';
import 'package:location/location.dart';
import 'package:format/format.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:get_location_app/models/coordinates.dart';

class RecordScreen extends StatefulWidget {
  final int seconds;
  final Location location;

  const RecordScreen(
      {super.key, required this.seconds, required this.location});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final List<Coordinates> _positionList = [];
  int _secondsElapsed = 0;

  StreamSubscription<LocationData>? _locationSubscription;

  Future<void> _listenLocation() async {
    log((await widget.location.isBackgroundModeEnabled()).toString());
    await widget.location.changeSettings(
        accuracy: LocationAccuracy.navigation, interval: widget.seconds * 1000);

    _locationSubscription =
        widget.location.onLocationChanged.handleError((dynamic err) {
      log(err.toString());
    }).listen((LocationData currentLocation) {
      if (currentLocation.latitude == null ||
          currentLocation.latitude == null) {
        return;
      }

      double lat = currentLocation.latitude as double;
      double lon = currentLocation.longitude as double;
      Coordinates coords = Coordinates(lat, lon);
      _positionList.add(coords);
      log(coords.toString());
    });
  }

  Future<void> _stopListen() async {
    await _locationSubscription?.cancel();
  }

  void _initClock() async {
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          _secondsElapsed += 1;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _listenLocation();
    _initClock();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    _stopListen();
    WakelockPlus.disable();
    super.dispose();
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
              secondsToClockString(_secondsElapsed),
              style: const TextStyle(fontSize: 32),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context, _positionList);
                },
                child: const Text("Stop")),
          ),
        ],
      )),
    );
  }
}
