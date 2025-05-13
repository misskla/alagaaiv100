import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';
//import 'assistive_touch.dart';
//import 'assistive_touch_handler.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await dotenv.load();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up MethodChannel to receive SRMS from native Android code
  /*const MethodChannel smsChannel = MethodChannel('alagaai/sms');

  smsChannel.setMethodCallHandler((call) async {
    if (call.method == 'incomingSMS') {
      String message = call.arguments;
      AssistiveTouchHandler.handleMessage(message);
    }
  });*/


  runApp(const MyApp());
}

// GlobalKey to access the AssistiveTouch state from outside
//final GlobalKey<AssistiveTouchState> assistiveTouchKey = GlobalKey();


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      /*builder: (context, child) {
        return Stack(
          children: [
            child!, // your screen
            AssistiveTouch(key: assistiveTouchKey), // always-on-top bubble
          ],
        );
      },*/
    );
  }
}
