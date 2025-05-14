import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gemini_service.dart';

Future<void> saveToLocal(String message) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> messages = prefs.getStringList('local_alerts') ?? [];
  messages.add(message);
  await prefs.setStringList('local_alerts', messages);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

Future<void> storeTriggerAlert(String message) async {
  await FirebaseFirestore.instance.collection('trigger_alerts').add({
    'message': message,
    'timestamp': FieldValue.serverTimestamp(),
  });
}

class _MyAppState extends State<MyApp> {
  final gemini = GeminiService();
  static const EventChannel _smsEventChannel = EventChannel("alagaaiv100/sms_event");

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  String _latestSms = "No SMS received yet.";
  String _triggeredMessage = "";
  bool _showOverlay = false;

  /*void startFloatingBubble() async {
    const platform = MethodChannel('bubble_channel');
    try {
      await platform.invokeMethod('startBubble');
    } catch (e) {
      print("Error starting bubble: $e");
    }
  }*/

  @override
  void initState() {
    super.initState();



    // Local notification setup
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    flutterLocalNotificationsPlugin.initialize(initSettings);

    // 🔌 SMS EventChannel listener
    _smsEventChannel.receiveBroadcastStream().listen((message) async {
      if (message is String) {
        setState(() {
          _latestSms = message;
        });

        print("📲 Received SMS from native: $message");

        final (isRisky, explanation) = await gemini.analyzeMessageWithExplanation(message);

        if (isRisky) {
          print("⚠️ Gemini flagged risky: $explanation");

          setState(() {
            _triggeredMessage = "⚠️ Trigger Alert: Potentially risky message detected.";
            _showOverlay = true;
          });

          await storeTriggerAlert("$message\n\nAI: $explanation");
          await saveToLocal("$message\n\nAI: $explanation");
          await _sendNotification(message, explanation);

          Future.delayed(const Duration(seconds: 10), () {
            if (mounted) setState(() => _showOverlay = false);
          });
        } else {
          print("✅ Gemini says safe: $explanation");
        }
      }
    });

    // 🧪 Manual Gemini Test (runs on startup)
    Future.delayed(Duration(seconds: 3), () async {
      final testMessage = "Don't tell anyone. Can you meet me later?";
      print("🧪 Sending test message to Gemini...");

      try {
        final (isRisky, explanation) = await gemini.analyzeMessageWithExplanation(testMessage);

        if (isRisky) {
          print("🧪 Gemini flagged test message: $explanation");

          setState(() {
            _triggeredMessage = "⚠️ Trigger Alert: Potentially risky message detected.";
            _showOverlay = true;
          });

          await storeTriggerAlert("$testMessage\n\nAI: $explanation");
          await saveToLocal("$testMessage\n\nAI: $explanation");
          await _sendNotification(testMessage, explanation);

          Future.delayed(const Duration(seconds: 10), () {
            if (mounted) setState(() => _showOverlay = false);
          });
        } else {
          print("🧪 Gemini says test message is safe: $explanation");
        }
      } catch (e) {
        print("❌ Gemini test failed: $e");
      }
    });

  }


  Future<void> _sendNotification(String message, String explanation) async {
    const androidDetails = AndroidNotificationDetails(
      'sms_channel_id',
      'SMS Trigger Alerts',
      channelDescription: 'Triggered when risky SMS content is detected',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      '⚠️ Trigger Word Detected',
      '$message\n\nAI says: $explanation',
      platformDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          const SplashScreen(),
          if (_showOverlay)
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "⚠️ Trigger Word Detected",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _triggeredMessage,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        splashRadius: 20,
                        onPressed: () {
                          setState(() => _showOverlay = false);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
