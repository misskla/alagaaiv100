import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';
import 'assistive_touch.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // initial screen
      builder: (context, child) {
        return Stack(
          children: [
            child!,             // 👈 your current screen (Splash, Home, etc.)
            AssistiveTouch(),   // 👈 always-on-top floating bubble
          ],
        );
      },
    );
  }
}