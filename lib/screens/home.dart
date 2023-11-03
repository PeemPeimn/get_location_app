import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_location_app/models/coordinates.dart';
import 'package:get_location_app/screens/data.dart';
import 'package:get_location_app/screens/record.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String testText = "";
  List<List<Coordinates>> dataList = [];
  var inputController = TextEditingController();

  void toRecord(BuildContext context) async {
    try {
      var seconds = int.parse(inputController.text);

      if (seconds < 1) {
        throw "Input second must be >= 1";
      }

      await requestPermission();

      if (!context.mounted) return;

      var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecordScreen(seconds: seconds),
        ),
      );

      dataList.add(result as List<Coordinates>);

      // log(dataList.toString());
    } catch (e) {
      if (!context.mounted) return;

      alert(context, e.toString());
    }
  }

  void toData(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataScreen(dataList: dataList),
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
            "Record location \nevery x second(s)",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Container(
            width: 150,
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: inputController,
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
                toRecord(context);
              },
              child: const Text("Start"),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: FilledButton(
                onPressed: () {
                  toData(context);
                },
                child: const Text("Data")),
          ),
        ],
      )),
    );
  }
}

Future<void> requestPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
}

Future<void> alert(BuildContext context, String errorMessage) {
  return showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
