import 'dart:async';
import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int dotCount = 6;
  int activeDotIndex = 0;
  Timer? _dotTimer;

  @override
  void initState() {
    super.initState();

    // Start dot animation loop manually
    _dotTimer = Timer.periodic(const Duration(milliseconds: 350), (timer) {
      setState(() {
        activeDotIndex = (activeDotIndex + 1) % dotCount;
      });
    });

    // After 8.5 seconds, stop animation and go to welcome screen
    Future.delayed(const Duration(milliseconds: 8500), () {
      _dotTimer?.cancel();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, secondaryAnimation) =>
            const WelcomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _dotTimer?.cancel();
    super.dispose();
  }

  Widget buildDot(int index, int activeIndex) {
    final bool isActive = index == activeIndex;
    final double width = 8.0;
    final double height = isActive ? 24.0 : 16.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF36F9B) : const Color(0xFF80C1F1),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/final logo.png', width: 200, height: 200),
            const SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                dotCount,
                    (index) => buildDot(index, activeDotIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
