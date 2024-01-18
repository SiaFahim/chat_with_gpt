import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GPTService {
  final _storage = FlutterSecureStorage();
  final _apiUrl = 'https://api.openai.com/v1/chat/completions'; // Updated endpoint

  Future<String> getResponse(String userMessage) async {
    final apiKey = await _storage.read(key: 'openai_api_key');
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'model': 'gpt-4', // Specify the model as "gpt-4"
      'messages': [
        {
          'role': 'system',
          'content': 'You are a helpful assistant.'
        },
        {
          'role': 'user',
          'content': userMessage,
        },
      ],
    });

    try {
      final response = await http.post(Uri.parse(_apiUrl), headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        throw Exception('Failed to get response from GPT: ${response.body}');
      }
    } 
    catch (e) {
      print('Error occurred: $e'); // Added for debugging
      rethrow;
    }
  }
}
