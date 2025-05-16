
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_info.dart';
import 'dashboard_screen.dart';
import 'search_professionals_screen.dart';
import 'chat_screen.dart';
import 'notifications_screen.dart';
import 'welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  final UserInfo userInfo;

  const ProfileScreen({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Banner with Overlapping Profile Image
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFBDA9F6),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/final logo.png',
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(userInfo.profileImage),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),

            Text(
              userInfo.name.toUpperCase(),
              style: GoogleFonts.kodchasan(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5A3DA0),
              ),
            ),
            Text(
              userInfo.role,
              style: GoogleFonts.kodchasan(
                fontSize: 14,
                color: const Color(0xFF5A3DA0),
              ),
            ),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Address"),
                  _buildValue(
                    "73 Corrales Ave, Cagayan de Oro,\n9000 Misamis Oriental",
                  ),
                  const SizedBox(height: 16),
                  _buildLabel("Contact Details"),
                  _buildValue(
                    "73 Corrales Ave, Cagayan de Oro,\n9000 Misamis Oriental",
                  ),
                  const SizedBox(height: 16),
                  if (userInfo.role == 'Parent') ...[
                    _buildLabel("CHILDREN"),
                    _buildValue("Peter Reyes"),
                    _buildValue("Mary Reyes"),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Edit Profile is not available yet.'),
                    duration: Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC94D),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                "Edit Profile",
                style: GoogleFonts.kodchasan(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7EA2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                "Log Out",
                style: GoogleFonts.kodchasan(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
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
                  // You can add navigation to ProfileScreen here if needed
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
    return Text(label,
      style: GoogleFonts.kodchasan(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF5A3DA0),
      ),
    );
  }

  Widget _buildValue(String value) {
    return Text(value,
      style: GoogleFonts.kodchasan(fontSize: 13, color: const Color(0xFFFF7EA2)),
    );
  }
}
