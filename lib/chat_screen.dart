import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_info.dart';
import 'dashboard_screen.dart';
import 'search_professionals_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'widgets/alert_bubble.dart';
import 'gemini_service.dart';

class ChatScreen extends StatefulWidget {
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
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService = GeminiService();

  final List<Map<String, String>> _messages = [
    {'role': 'bot', 'text': 'What can I help you with?'} // 👋 Initial bot message
  ];

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _controller.clear();
    });

    if (widget.isAI) {
      final reply = await _geminiService.sendMessage(text);
      setState(() {
        _messages.add({'role': 'bot', 'text': reply});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFD),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                if (msg['role'] == 'user') {
                  return _buildUserMessage(msg['text']!, widget.userInfo.profileImage);
                } else {
                  return _buildBotMessage(msg['text']!);
                }
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: const Color(0xFF5A3DA0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              widget.imagePath,
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
                  widget.title,
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
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Column(
        children: [
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
                    controller: _controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type your message here.',
                      hintStyle: GoogleFonts.kodchasan(fontSize: 14),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _sendMessage,
                child: CircleAvatar(
                  backgroundColor: const Color(0xFF5A3DA0),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
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

  Widget _buildBottomNav(BuildContext context) {
    return SafeArea(
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => DashboardScreen(userInfo: widget.userInfo)),
                );
              }),
              _navButton(context, 'assets/nav_search.png', () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => SearchProfessionalsScreen(userInfo: widget.userInfo)),
                );
              }),
              _navButton(context, 'assets/nav_brain.png', () {}),
              _navButton(context, 'assets/nav_messages.png', () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => NotificationsScreen(userInfo: widget.userInfo)),
                );
              }),
              _navButton(context, 'assets/nav_profile.png', () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen(userInfo: widget.userInfo)),
                );
              }),
            ],
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
}
