import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_info.dart';
import 'dashboard_screen.dart';
import 'search_professionals_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'widgets/alert_bubble.dart';

class ChatScreen extends StatelessWidget {
  final bool isAI;
  final String title;
  final String imagePath;
  final UserInfo userInfo;

  const ChatScreen({
    super.key,
    required this.title,
    required this.imagePath,
    required this.isAI,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFD),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            color: const Color(0xFF5A3DA0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    imagePath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.kodchasan(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "● Online",
                        style: GoogleFonts.kodchasan(
                          fontSize: 12,
                          color: Colors.lightGreenAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
          ),

          Expanded(
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildBotMessage("Hello! How can I assist you today?"),
                    _buildUserMessage("Can I see a therapist?", userInfo.profileImage),
                    _buildBotMessage("Sure, here’s a good recommendation."),
                    _buildUserMessage("Thank you!", userInfo.profileImage),
                  ],
                ),

                // Hovered alert bubble at top-right
                const Positioned(
                  top: 20,
                  right: 12,
                  child: AlertBubble(),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickReply("What's WappGPT?"),
                    _buildQuickReply("Pricing"),
                    _buildQuickReply("FAQs"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type your message here.',
                            hintStyle: GoogleFonts.kodchasan(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: const Color(0xFF5A3DA0),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation
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
                _navButton(context, 'assets/nav_home.png', () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => DashboardScreen(userInfo: userInfo)));
                }),
                _navButton(context, 'assets/nav_search.png', () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => SearchProfessionalsScreen(userInfo: userInfo)));
                }),
                _navButton(context, 'assets/nav_brain.png', () {}), // current screen
                _navButton(context, 'assets/nav_messages.png', () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => NotificationsScreen(userInfo: userInfo)));
                }),
                _navButton(context, 'assets/nav_profile.png', () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => ProfileScreen(userInfo: userInfo)));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navButton(BuildContext context, String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(assetPath, width: 60, height: 60),
    );
  }

  Widget _buildBotMessage(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF5A3DA0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: GoogleFonts.kodchasan(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildUserMessage(String text, String profileImagePath) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(text, style: GoogleFonts.kodchasan(fontSize: 14)),
          ),
          const SizedBox(width: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              profileImagePath,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReply(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.kodchasan(fontSize: 12, color: Colors.black87),
      ),
    );
  }
}
