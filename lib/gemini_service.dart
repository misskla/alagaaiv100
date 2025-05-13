import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService()
      : _model = GenerativeModel(
    model: 'gemini-1.5-flash-001',
    apiKey: 'AIzaSyA_lsB1pueER84f_QuFr4TswqMFoqwBnXE',
  );

  Future<String> sendMessage(String message) async {
    try {
      final response = await _model.generateContent([
        Content.text(message),
      ]);
      return response.text ?? 'No response';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
