import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_info.dart';
import 'dashboard_screen.dart';
import 'doctor_details_screen.dart';
import 'chat_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class SearchProfessionalsScreen extends StatelessWidget {
  final UserInfo userInfo;

  const SearchProfessionalsScreen({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/final logo.png',
                  width: 110,
                  height: 110,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Nearby Professionals!",
                style: GoogleFonts.kodchasan(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5A3DA0),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search a therapist',
                          hintStyle: GoogleFonts.kodchasan(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7EA2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dr. Josephine Reyes •",
                            style: GoogleFonts.kodchasan(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Clinical Psychologist\n\n73 Corrales Ave,\nCagayan de Oro,\n9000 Misamis Oriental",
                            style: GoogleFonts.kodchasan(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => DoctorDetailsScreen(
                                    userInfo: userInfo,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC94D),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Book now",
                              style: GoogleFonts.kodchasan(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/doctor_profile.png',
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
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
                  onTap: () {}, // already on search
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
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotificationsScreen(userInfo: userInfo),
                      ),
                    );
                  },
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
