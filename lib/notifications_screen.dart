import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_info.dart';
import 'dashboard_screen.dart';
import 'search_professionals_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsScreen extends StatefulWidget {
  final UserInfo userInfo;

  const NotificationsScreen({super.key, required this.userInfo});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
              // Header
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
                  Text(
                    "Mark all as read",
                    style: GoogleFonts.kodchasan(
                      fontSize: 14,
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 🔥 Firestore alert notifications
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
                        final message = data['message'] ?? '';
                        final timestamp = data['timestamp']?.toDate();

                        return Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  'assets/nav_brain.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message,
                                      style: GoogleFonts.kodchasan(fontSize: 14),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      timestamp != null
                                          ? "Received at ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}"
                                          : "Time unknown",
                                      style: GoogleFonts.kodchasan(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                GestureDetector(
                  onTap: () {}, // current screen
                  child: Image.asset('assets/nav_messages.png', width: 60, height: 60),
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
