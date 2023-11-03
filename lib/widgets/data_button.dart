// import 'dart:developer';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get_location_app/models/coordinates.dart';

class DataButton extends StatelessWidget {
  final String buttonName;
  final List<Coordinates> locationList;

  const DataButton({
    super.key,
    required this.buttonName,
    required this.locationList,
  });

  @override
  Widget build(BuildContext context) {
    String json = jsonEncode(locationList);

    return Container(
      padding: const EdgeInsets.all(2.5),
      child: FilledButton(
          onPressed: () {
            popup(context, json);
          },
          child: Text(buttonName)),
    );
  }
}

Future<void> popup(BuildContext context, String json) {
  return showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('JSON'),
        content: SingleChildScrollView(
          child: Text(json),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Copy to clipboard'),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: json));
            },
          ),
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
