import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() {
  test('Test retrieval of OpenAI API key from .env file', () async {
    await DotEnv.dotenv.load(fileName: ".env");

    // Retrieve the API key
    final apiKey = DotEnv.dotenv.env['OPENAI_API_KEY'];

    // Check if the retrieved key is not null
    expect(apiKey, isNotNull);
  });
}