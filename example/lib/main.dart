import 'dart:async';

import 'package:battery_state_reader/battery_state_reader.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _batteryPercentage = -1;
  String _batteryStatus = "unknown";

  @override
  void initState() {
    super.initState();
    initBatteryEntries();
  }

  Future<void> initBatteryEntries() async {
    _batteryPercentage = await BatteryStateReader.batteryPercentage;
    _batteryStatus = await BatteryStateReader.batteryStatus;

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BatteryStateReader example app'),
        ),
        body: Stack(children: [
          Center(
            child: Text(
              '$_batteryPercentage%\n\n'
              '$_batteryStatus',
              style: TextStyle(fontSize: 64),
              textAlign: TextAlign.center,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: StreamBuilder(
                stream: BatteryStateReader.batteryStateChanged,
                builder: (context, state) {
                  Color batteryStateColor;
                  var batteryState = state.data;
                  if (batteryState == "discharging" ||
                      batteryState == "unknown") {
                    batteryStateColor = Colors.red;
                  } else {
                    batteryStateColor = Colors.green;
                  }
                  return Text(
                    batteryState,
                    style: TextStyle(
                      fontSize: 64,
                      color: batteryStateColor,
                    ),
                  );
                }),
          )
        ]),
      ),
    );
  }
}
