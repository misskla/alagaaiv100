import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_info.dart';
import 'dashboard_screen.dart';
import 'search_professionals_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class NotificationsScreen extends StatelessWidget {
  final UserInfo userInfo;

  const NotificationsScreen({super.key, required this.userInfo});

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

              // Single Notification Card
              Container(
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
                        'assets/doctor_profile.png',
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
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.kodchasan(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(text: "Dr. Josephine Reyes "),
                                const TextSpan(text: "requested access to "),
                                TextSpan(
                                  text: "your appointment details.",
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text("Approve"),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade300,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text("Decline"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Today at 9:42 AM",
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
                        builder: (_) => DashboardScreen(userInfo: userInfo),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/nav_home.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                SearchProfessionalsScreen(userInfo: userInfo),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/nav_search.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ChatScreen(
                              title: "Chatbot",
                              imagePath: 'assets/nav_brain.png',
                              isAI: true,
                              userInfo: userInfo,
                            ),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/nav_brain.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                GestureDetector(
                  onTap: () {}, // current screen
                  child: Image.asset(
                    'assets/nav_messages.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(userInfo: userInfo),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/nav_profile.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
