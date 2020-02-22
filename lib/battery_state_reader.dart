import 'dart:async';

import 'package:flutter/services.dart';

class BatteryStateReader {
  static const MethodChannel _channel =
      const MethodChannel('battery_state_reader');

  static Future<String> get batteryStatus async {
    final String batteryStatus =
        await _channel.invokeMethod('getBatteryStatus');
    return batteryStatus;
  }

  static Future<int> get batteryPercentage async {
    final int batteryPercentage =
        await _channel.invokeMethod('getBatteryPercentage');
    return batteryPercentage;
  }
}
