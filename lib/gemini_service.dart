import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService()
      : _model = GenerativeModel(
    model: 'gemini-1.5-flash-001',
    apiKey: 'AIzaSyA_lsB1pueER84f_QuFr4TswqMFoqwBnXE', // Replace if needed
  );

  Future<String> sendMessage(String message) async {
    try {
      final response = await _model.generateContent([Content.text(message)]);
      return response.text ?? 'No response';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<(bool, String)> analyzeMessageWithExplanation(String message) async {
    final prompt = '''
You are an AI safety assistant. Analyze the following SMS message for risk. Indicate whether it’s harmful (grooming, abuse, sexual, mental health distress, etc.), and explain why.

Message: "$message"

Start your reply with "true:" if risky or "false:" if safe, followed by the reason.
''';

    final response = await sendMessage(prompt);
    final raw = response.toLowerCase().replaceAll("**", "").trim();
    print("🤖 Gemini raw: $raw");

    if (raw.startsWith("true:")) {
      return (true, raw.replaceFirst("true:", "").trim());
    } else if (raw.startsWith("false:")) {
      return (false, raw.replaceFirst("false:", "").trim());
    } else {
      return (false, "Unclear response from AI");
    }
  }


}
