import 'package:flutter/services.dart';

class NetworkSpeedService {
  static const platform = MethodChannel('netpulse');

  Future<void> start() async {
    await platform.invokeMethod('startService');
  }

  Future<void> stop() async {
    await platform.invokeMethod('stopService');
  }

  Future<Map<String, dynamic>> getTotals() async {
    try {
      final result = await platform.invokeMethod('getTotals');
      if (result == null) return {'download': 0, 'upload': 0};
      return Map<String, dynamic>.from(result);
    } catch (e) {
      return {'download': 0, 'upload': 0};
    }
  }
}