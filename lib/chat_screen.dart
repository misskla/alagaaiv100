import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_info.dart';
import 'dashboard_screen.dart';
import 'search_professionals_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'widgets/alert_bubble.dart';
import 'gemini_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatScreen extends StatefulWidget {
  final bool isAI;
  final String title;
  final String imagePath;
  final UserInfo userInfo;
  final String? initialMessage;


  const ChatScreen({
    super.key,
    required this.title,
    required this.imagePath,
    required this.isAI,
    required this.userInfo,
    this.initialMessage
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  late final bool isParent;

  final List<Map<String, String>> _messages = [
    {'role': 'bot', 'text': 'What can I help you with?'} // 👋 Initial bot message
  ];

  @override
  void initState() {
    super.initState();
    isParent = widget.userInfo.role.toLowerCase() == 'parent';

    // ✅ Show initial message once and get AI response
    if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
      _messages.add({'role': 'user', 'text': widget.initialMessage!});

      if (widget.isAI) {
        _geminiService.sendMessage(widget.initialMessage!).then((reply) {
          setState(() {
            _messages.add({'role': 'bot', 'text': reply});
          });
        });
      }
    }
  }


  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _controller.clear();
    });

    if (widget.isAI) {
      String userInput = text;

      // ✅ Customized prompt based on user role
      String customPrompt = isParent
          ? "You are an AI assistant helping a concerned parent. Respond in a clear and informative way to help them understand or support their child. Question: $userInput"
          : "You are a supportive AI talking to a child. Be caring, safe, and explain things simply. If it's a risky situation, give calm, clear advice. Question: $userInput";

      final reply = await _geminiService.sendMessage(customPrompt);

      setState(() {
        _messages.add({'role': 'bot', 'text': reply});
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFD),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 80), // ⬅ padding to avoid being covered by the button
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

          // ⬇ Floating Therapist Button
          Positioned(
            bottom: 90, // just above input bar
            left: 20,
            right: 20,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(30),
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchProfessionalsScreen(userInfo: widget.userInfo),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFB6F92), Color(0xFF8E44AD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.volunteer_activism, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        "Talk to a Therapist",
                        style: GoogleFonts.kodchasan(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
              errorBuilder: (context, error, stackTrace) {
                // This will show a fallback when the image fails to load
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.purple.shade200,
                  child: const Icon(Icons.person, color: Colors.white, size: 30),
                );
              },
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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  text,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: GoogleFonts.kodchasan(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                profileImagePath,
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback for profile image
                  return Container(
                    width: 30,
                    height: 30,
                    color: Colors.grey.shade400,
                    child: const Icon(Icons.person, color: Colors.white, size: 16),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildBotMessage(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF5A3DA0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: MarkdownBody(
            data: text,
            styleSheet: MarkdownStyleSheet(
              p: GoogleFonts.kodchasan(color: Colors.white, fontSize: 14),
              strong: GoogleFonts.kodchasan(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
