import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gemini_service.dart';
import 'chat_screen.dart';
import 'models/user_info.dart';

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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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
    const MethodChannel('alagaaiv100/bubble_redirect')
        .setMethodCallHandler((call) async {
      if (call.method == 'openChatFromBubble') {
        try {
          // Get current user ID (you may store this in SharedPreferences or use Firebase Auth)
          final prefs = await SharedPreferences.getInstance();
          final userId = prefs.getString('user_id');

          if (userId != null) {
            // Fetch user data from Firestore
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();

            if (userDoc.exists) {
              final userData = userDoc.data()!;

              // Create UserInfo from Firestore data
              final userInfo = UserInfo(
                name: userData['name'] ?? 'User',
                profileImage: 'assets/nav_profile.png', // Use default image or a profile pic URL from Firestore
                role: userData['role'] ?? 'Child',
              );

              // Navigate to chat screen with user data
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    title: 'AI Assistant',
                    imagePath: 'assets/nav_brain.png',
                    isAI: true,
                    userInfo: userInfo,
                  ),
                ),
                    (route) => false,
              );
            } else {
              // If user doesn't exist in Firestore, use default values
              _navigateWithDefaultUser();
            }
          } else {
            // If no user ID stored, use default values
            _navigateWithDefaultUser();
          }
        } catch (e) {
          print("Error fetching user data: $e");
          // Fallback to default if there's an error
          _navigateWithDefaultUser();
        }
      }
    });
  }
  void _navigateWithDefaultUser() {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          title: 'AI Assistant',
          imagePath: 'assets/nav_brain.png',
          isAI: true,
          userInfo: UserInfo(
            name: 'User',
            profileImage: 'assets/nav_profile.png',
            role: 'Child',
          ),
        ),
      ),
          (route) => false,
    );
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
      navigatorKey: navigatorKey,
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
