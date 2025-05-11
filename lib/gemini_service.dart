import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: 'YOUR_API_KEY', // Use .env in production
  );

  Future<String> analyzeText(String input) async {
    final content = [Content.text("Is this message grooming-related? '$input'")];
    final response = await model.generateContent(content);
    return response.text ?? 'No result';
  }

  Future<String> suggestResponse(String message) async {
    final content = [
      Content.text("Suggest a friendly response to this suspicious message: '$message'")
    ];
    final response = await model.generateContent(content);
    return response.text ?? 'No suggestion';
  }
}
