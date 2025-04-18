import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = String.fromEnvironment( "gemini", defaultValue: "none" );

Future<String> pipe( String prompt ) async {
  final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey
  );

  final content = [ Content.text(prompt) ];
  final response = await model.generateContent(content);

  return response.text ?? "ERROR";
}