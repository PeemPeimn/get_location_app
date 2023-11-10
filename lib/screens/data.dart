import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:get_location_app/models/coordinates.dart';
import 'package:get_location_app/widgets/data_button.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final _box = Hive.box<List>('data');

  void _delete(dynamic key) {
    _box.delete(key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dataButtons = [];
    for (var key in _box.keys) {
      List<dynamic> data = _box.get(key, defaultValue: [])!;
      List<Coordinates> coordinatesList = data.cast<Coordinates>();

      dataButtons.add(DataButton(
        buttonName: key,
        locationList: coordinatesList,
        deleteFunc: _delete,
      ));
    }

    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(100),
            child: Center(
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ...dataButtons,
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.teal),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Back")),
                  ),
                ],
              )),
            )));
  }
}
