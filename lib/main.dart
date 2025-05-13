import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> storeTriggerAlert(String message) async {
  final alertsCollection =
  FirebaseFirestore.instance.collection('trigger_alerts');

  await alertsCollection.add({
    'message': message,
    'timestamp': FieldValue.serverTimestamp(),
  });
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

class _MyAppState extends State<MyApp> {
  static const EventChannel _smsEventChannel =
  EventChannel("alagaaiv100/sms_event");

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  String _latestSms = "No SMS received yet.";

  final List<String> _triggerWords = [
    "secret",
    "abuse",
    "don't tell",
    "meet up",
    "alone",
    "unsafe"
  ];

  @override
  void initState() {
    super.initState();

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Listen to incoming SMS from native side
    _smsEventChannel.receiveBroadcastStream().listen((message) async {
      if (message is String) {
        setState(() {
          _latestSms = message;
        });

        print("📲 Received SMS from native: $message");

        if (_containsTrigger(message)) {
          _showWarningDialog(message);
          await storeTriggerAlert(message); // Save to Firestore
          await _sendNotification(message); // Show system notif
        }
      }
    });
  }

  bool _containsTrigger(String message) {
    return _triggerWords.any(
          (word) => message.toLowerCase().contains(word.toLowerCase()),
    );
  }

  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("⚠️ Trigger Word Detected"),
        content: Text("Message contains risky content:\n\n\"$message\""),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Dismiss"),
          ),
        ],
      ),
    );
  }

  Future<void> _sendNotification(String message) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'sms_channel_id',
      'SMS Trigger Alerts',
      channelDescription: 'Triggered when risky SMS content is detected',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      '⚠️ Trigger Word Detected',
      message,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              padding: const EdgeInsets.all(10),
              color: Colors.black.withOpacity(0.7),
              child: Text(
                _latestSms,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
