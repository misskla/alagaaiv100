import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertBubble extends StatelessWidget {
  const AlertBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 12, left: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // ✅ Align tops
          children: [
            // 🔴 Left: Prompt message bubble
            Container(
              constraints: const BoxConstraints(maxWidth: 220),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Text(
                "Jake, are you okay with this?",
                style: GoogleFonts.kodchasan(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // 🛡️ Right: Logo and Yes/No buttons
            Column(
              children: [
                CircleAvatar(
                  radius: 26, // Adjust for logo size
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/final logo.png',
                    width: 36,
                    height: 36,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle No
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7EA2),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "No",
                    style: GoogleFonts.kodchasan(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: () {
                    // Handle Yes
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB2EBF2),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Yes",
                    style: GoogleFonts.kodchasan(color: Colors.black87),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
