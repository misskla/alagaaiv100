import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_info.dart';
import 'dashboard_screen.dart';
import 'search_professionals_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  final UserInfo userInfo;

  const NotificationsScreen({super.key, required this.userInfo});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Future<void> _markAllAsRead() async {
    final snapshots = await FirebaseFirestore.instance
        .collection('trigger_alerts')
        .get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<int> getUnreadCount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('trigger_alerts')
        .get();
    return snapshot.size;
  }

  String extractMessageOnly(String fullMessage) {
    return fullMessage.split('\n\nAI:').first.trim();
  }

  String extractExplanation(String fullMessage) {
    final parts = fullMessage.split('\n\nAI:');
    return parts.length > 1 ? parts[1].trim() : "No explanation.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notifications",
                    style: GoogleFonts.kodchasan(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5A3DA0),
                    ),
                  ),
                  GestureDetector(
                    onTap: _markAllAsRead,
                    child: Text(
                      "Mark all as read",
                      style: GoogleFonts.kodchasan(
                        fontSize: 14,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('trigger_alerts')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data!.docs;
                    if (docs.isEmpty) {
                      return const Center(child: Text("No alerts yet."));
                    }
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        final timestamp = data['timestamp']?.toDate();
                        return NotificationCard(
                          senderName: widget.userInfo.name,
                          date: timestamp != null
                              ? "${timestamp.month}/${timestamp.day}/${timestamp.year}"
                              : "Unknown date",
                          time: timestamp != null
                              ? "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}"
                              : "Unknown time",
                          alertLevel: "High Level",
                          aiExplanation: extractExplanation(data['message'] ?? '').length > 0
                              ? "⚠️ Potentially risky message"
                              : "✅ Safe message",
                          message: extractMessageOnly(data['message'] ?? ''),
                          userInfo: widget.userInfo,
                          onChatbotPressed: () {
                            final sms = extractMessageOnly(data['message'] ?? '');
                            final ai = extractExplanation(data['message'] ?? '');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  title: "Chatbot",
                                  imagePath: 'assets/nav_brain.png',
                                  isAI: true,
                                  userInfo: widget.userInfo,
                                  initialMessage: "A potentially risky message was detected:\n\n\"$sms\"\n\nWould you like to talk about it?",

                                ),
                              ),
                            );
                          },

                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          elevation: 0,
          color: const Color(0xFFF9FFFD),
          child: Container(
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F7FB),
              borderRadius: BorderRadius.circular(40),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DashboardScreen(userInfo: widget.userInfo),
                      ),
                    );
                  },
                  child: Image.asset('assets/nav_home.png', width: 60, height: 60),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchProfessionalsScreen(userInfo: widget.userInfo),
                      ),
                    );
                  },
                  child: Image.asset('assets/nav_search.png', width: 60, height: 60),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          title: "Chatbot",
                          imagePath: 'assets/nav_brain.png',
                          isAI: true,
                          userInfo: widget.userInfo,
                        ),
                      ),
                    );
                  },
                  child: Image.asset('assets/nav_brain.png', width: 60, height: 60),
                ),
                FutureBuilder<int>(
                  future: getUnreadCount(),
                  builder: (context, snapshot) {
                    int count = snapshot.data ?? 0;
                    return Stack(
                      children: [
                        Image.asset('assets/nav_messages.png', width: 60, height: 60),
                        if (count > 0)
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(userInfo: widget.userInfo),
                      ),
                    );
                  },
                  child: Image.asset('assets/nav_profile.png', width: 60, height: 60),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
