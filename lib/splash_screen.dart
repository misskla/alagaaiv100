import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotIndex;

  final int dotCount = 6;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _dotIndex = StepTween(
      begin: 0,
      end: dotCount - 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    // Start the first animation loop
    _controller.forward();

    // Repeat manually to ensure the last dot is visible
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.forward(from: 0);
      }
    });

    // After 10 seconds, stop animation and transition
    Future.delayed(const Duration(seconds: 10), () {
      _controller.stop();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder:
                (context, animation, secondaryAnimation) =>
            const WelcomeScreen(),
            transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
                ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
            AnimatedBuilder(
              animation: _dotIndex,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    dotCount,
                        (index) => buildDot(index, _dotIndex.value),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
