import 'package:flutter/services.dart';

class PlatformService {
  static const platform = MethodChannel('alagaai/overlay');

  Future<void> showOverlay() async {
    try {
      await platform.invokeMethod('showBubble');
    } on PlatformException catch (e) {
      print("Overlay error: ${e.message}");
    }
  }
}
