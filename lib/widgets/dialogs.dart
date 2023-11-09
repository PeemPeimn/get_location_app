import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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

Future<void> alertRequestPermission(
    BuildContext context, String title, errorMessage) {
  return showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            child: const Text('Open App Settings'),
            onPressed: () => openAppSettings(),
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
