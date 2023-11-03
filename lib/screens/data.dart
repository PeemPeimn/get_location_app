import 'package:flutter/material.dart';
import 'package:get_location_app/models/coordinates.dart';
import 'package:get_location_app/widgets/data_button.dart';

class DataScreen extends StatefulWidget {
  final List<List<Coordinates>> dataList;

  const DataScreen({super.key, required this.dataList});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> dataButtons = [];
    for (int i = 0; i < widget.dataList.length; i++) {
      dataButtons.add(
        DataButton(
            buttonName: (i + 1).toString(), locationList: widget.dataList[i]),
      );
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
