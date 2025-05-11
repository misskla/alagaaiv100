import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _navigateToAuth(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AuthScreen(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFD),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/final logo.png', width: 130, height: 130),
              const SizedBox(height: 30),
              Text(
                "Who’s with us today?",
                style: GoogleFonts.kodchasan(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF5A3DA0),
                ),
              ),
              const SizedBox(height: 40),

              // Parent Button
              SizedBox(
                width: 250,
                height: 45,
                child: ElevatedButton(
                  onPressed: () => _navigateToAuth(context, 'Parent'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC94D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Parent",
                    style: GoogleFonts.kodchasan(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "or",
                style: GoogleFonts.kodchasan(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              // Child Button
              SizedBox(
                width: 250,
                height: 45,
                child: ElevatedButton(
                  onPressed: () => _navigateToAuth(context, 'Child'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7EA2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Child",
                    style: GoogleFonts.kodchasan(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
