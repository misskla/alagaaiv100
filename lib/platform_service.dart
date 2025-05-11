import 'package:flutter/services.dart';

class PlatformService {
  static const platform = MethodChannel('alagaai/channel');

  Future<void> startAccessibility() async {
    try {
      await platform.invokeMethod('startService');
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }
}
