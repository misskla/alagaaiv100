import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_info.dart';
import 'dashboard_screen.dart';
import 'search_professionals_screen.dart';
import 'chat_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final UserInfo userInfo;

  const DoctorDetailsScreen({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView(
            children: [
              Center(
                child: Image.asset(
                  'assets/final logo.png',
                  width: 110,
                  height: 110,
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: GoogleFonts.kodchasan(
                    fontSize: 22,
                    color: const Color(0xFF5A3DA0),
                  ),
                  children: [
                    const TextSpan(text: "Hello there, "),
                    TextSpan(
                      text: "${userInfo.name}!",
                      style: const TextStyle(color: Color(0xFFFF7EA2)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "Active Courses",
                style: GoogleFonts.kodchasan(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF5A3DA0),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC94D),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/lock.png', width: 40),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Early Signs of Grooming",
                            style: GoogleFonts.kodchasan(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF5A3DA0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          height: 8,
                          width: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF7EA2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Feature coming soon!'),
                            duration: Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.deepPurpleAccent,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7EA2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: Text(
                        "Continue Learning",
                        style: GoogleFonts.kodchasan(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Feed",
                style: GoogleFonts.kodchasan(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF5A3DA0),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7EA2),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('assets/feed.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "'It's Showtime': What is considered as grooming. Vice Ganda explains",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.kodchasan(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Published April 29, 2024",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.kodchasan(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
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
                _navIcon(context, 'assets/nav_home.png', () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => DashboardScreen(userInfo: userInfo)),
                  );
                }),
                _navIcon(context, 'assets/nav_search.png', () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => SearchProfessionalsScreen(userInfo: userInfo)),
                  );
                }),
                _navIcon(context, 'assets/nav_brain.png', () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        title: "Chatbot",
                        imagePath: 'assets/nav_brain.png',
                        isAI: true,
                        userInfo: userInfo,
                      ),
                    ),
                  );
                }),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('trigger_alerts').snapshots(),
                  builder: (context, snapshot) {
                    final count = snapshot.data?.docs.length ?? 0;
                    return Stack(
                      children: [
                        _navIcon(context, 'assets/nav_messages.png', () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => NotificationsScreen(userInfo: userInfo)),
                          );
                        }),
                        if (count > 0)
                          Positioned(
                            top: 0,
                            right: 0,
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
                _navIcon(context, 'assets/nav_profile.png', () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => ProfileScreen(userInfo: userInfo)),
                  );
                }),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _navIcon(BuildContext context, String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(assetPath, width: 60, height: 60),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.kodchasan(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF5A3DA0),
      ),
    );
  }

  Widget _buildValue(String value) {
    return Text(
      value,
      style: GoogleFonts.kodchasan(
        fontSize: 13,
        color: const Color(0xFFFF7EA2),
      ),
    );
  }
}
