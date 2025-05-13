/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'gemini_service.dart';

class AssistiveTouchHandler {
  static final _gemini = GeminiService();

  static Future<void> handleMessage(String message) async {
    final result = await _gemini.analyzeText(message);

    if (result.toLowerCase().contains("grooming") ||
        result.toLowerCase().contains("unsafe") ||
        result.toLowerCase().contains("secret")) {

      final suggestion = await _gemini.suggestResponse(message);

      // Firebase log for parent
      await FirebaseFirestore.instance.collection('alerts').add({
        'timestamp': Timestamp.now(),
        'type': 'trigger_alert',
        'message': message,
        'receiver': 'parent',
      });

      // Show popup if app is open
      if (_activeContext != null) {
        showDialog(
          context: _activeContext!,
          builder: (_) => AlertDialog(
            title: const Text("⚠️ Sensitive Message Detected"),
            content: Text("You can reply:\n\n$suggestion"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(_activeContext!),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  static BuildContext? _activeContext;

  static void registerContext(BuildContext context) {
    _activeContext = context;
  }

  static void unregisterContext() {
    _activeContext = null;
  }
}
