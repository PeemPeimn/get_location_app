import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:get_location_app/models/exceptions.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:get_location_app/models/coordinates.dart';
import 'package:get_location_app/screens/data.dart';
import 'package:get_location_app/screens/record.dart';
import 'package:get_location_app/widgets/dialogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _backgroundMode = false;
  bool _warned = false;
  final Location _location = Location();
  final List<List<Coordinates>> _dataList = [];
  final _inputController = TextEditingController();

  Future<void> _requestPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw const PermissionDeniedException(
            "Location services are disabled.");
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw const PermissionDeniedException(
            "Location permissions are denied");
      }
    }

    if (permissionGranted == PermissionStatus.deniedForever) {
      throw const PermissionDeniedException(
          "Location permission are forever denied");
    }
  }

  Future<void> _toggleBackgroundMode(BuildContext context) async {
    try {
      if (!_warned) {
        await alertRequestPermission(context, "Warning",
            'To enable background mode, you have to change the location permission to "Always"\n\n\nNOTE: Web platform cannot use this function.');
        _warned = true;
      }
      await _location.enableBackgroundMode(
          enable: (_backgroundMode ? false : true));

      setState(() {
        _backgroundMode = (_backgroundMode ? false : true);
      });
      log("Background Mode: ${_backgroundMode.toString()}");
    } catch (e) {
      if (!context.mounted) return;

      alertRequestPermission(context, "Error",
          'Cannot enable background mode. Please change location permission to "Always"\n\n\nNOTE: Web platform cannot use this function.');
    }
  }

  void _toRecord(BuildContext context) async {
    try {
      var seconds = int.parse(_inputController.text);

      if (seconds < 1) {
        throw "Input second must be >= 1";
      }

      await _requestPermission();

      if (!context.mounted) return;

      var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecordScreen(
            seconds: seconds,
            location: _location,
          ),
        ),
      );

      _dataList.add(result as List<Coordinates>);

      // log(dataList.toString());
    } on PermissionDeniedException catch (e) {
      if (!context.mounted) return;

      alertRequestPermission(context, "Error", e.toString());
    } catch (e) {
      if (!context.mounted) return;

      alert(context, e.toString());
    }
  }

  void _toData(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataScreen(dataList: _dataList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Record location\non change\nevery x second(s)",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Container(
            width: 150,
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(
                // labelText: "Record every x second(s)",
                hintText: "second(s)",
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: FilledButton(
              onPressed: () {
                log("clicked");
                _toRecord(context);
              },
              child: const Text("Start"),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: FilledButton(
                onPressed: () {
                  _toData(context);
                },
                child: const Text("Data")),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: FilledButton(
              onPressed: () async {
                await _toggleBackgroundMode(context);
              },
              child: const Text("Toggle background mode"),
            ),
          ),
          Text("Backgound Mode: ${_backgroundMode ? "on" : "off"}"),
        ],
      )),
    );
  }
}
