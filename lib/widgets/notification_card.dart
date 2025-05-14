import 'package:flutter/material.dart';
import '../search_professionals_screen.dart';
import '../models/user_info.dart';

class NotificationCard extends StatelessWidget {
  final String senderName;
  final String date;
  final String time;
  final String alertLevel;
  final String aiExplanation;
  final String message;
  final UserInfo userInfo;
  final VoidCallback? onChatbotPressed;


  const NotificationCard({
    super.key,
    required this.senderName,
    required this.date,
    required this.time,
    required this.alertLevel,
    required this.aiExplanation,
    required this.message,
    required this.userInfo,
    this.onChatbotPressed

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                senderName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "$date $time",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            alertLevel.toUpperCase() + '!',
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            aiExplanation,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onChatbotPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Talk with Chatbot"),
                ),

              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchProfessionalsScreen(userInfo: userInfo),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Contact a Therapist"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ✅ Helper functions for parsing message from Firestore
String extractMessageOnly(String fullMessage) {
  return fullMessage.split('\n\nAI:').first.trim();
}

String extractExplanation(String fullMessage) {
  final parts = fullMessage.split('\n\nAI:');
  return parts.length > 1 ? parts[1].trim() : "No explanation.";
}
