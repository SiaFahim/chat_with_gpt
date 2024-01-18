import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'screens/chat_screen.dart'; // Ensure this path is correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv.dotenv.load(fileName: ".env");
  final storage = FlutterSecureStorage();
  final apiKey = DotEnv.dotenv.env['OPENAI_API_KEY'];

  if (apiKey != null) {
    await storage.write(key: 'openai_api_key', value: apiKey);
  }

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat with GPT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chat Home'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          },
          child: Text('Go to Chat'),
        ),
      ),
    );
  }
}
