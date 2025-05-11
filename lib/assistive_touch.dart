import 'package:flutter/material.dart';
import 'gemini_service.dart';

class AssistiveTouch extends StatefulWidget {
  @override
  _AssistiveTouchState createState() => _AssistiveTouchState();
}

class _AssistiveTouchState extends State<AssistiveTouch> {
  final gemini = GeminiService();
  bool isBubbleOpen = true;

  void analyzeSampleMessage() async {
    String result = await gemini.analyzeText("Hi! Can you keep a secret?");
    showDialog(context: context, builder: (_) => AlertDialog(content: Text(result)));
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // Hide on SplashScreen
    if (currentRoute == '/' || currentRoute == null) {
      return const SizedBox.shrink(); // render nothing
    }

    return Positioned(
      right: 10,
      bottom: 100,
      child: Draggable(
        feedback: _bubble(),
        childWhenDragging: Container(),
        child: GestureDetector(
          onTap: analyzeSampleMessage,
          child: _bubble(),
        ),
      ),
    );
  }

  Widget _bubble() => CircleAvatar(
    radius: 30,
    backgroundColor: Colors.blue,
    child: Icon(Icons.chat_bubble, color: Colors.white),
  );
}
