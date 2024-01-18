import 'package:flutter/material.dart';
import '../services/gpt_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> messages = [];
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final GPTService gptService = GPTService(); // Instance of GPTService

  void _sendMessage() async {
    final userMessage = messageController.text;
    if (userMessage.isNotEmpty) {
      setState(() {
        messages.add('You: $userMessage');
        messageController.clear();
      });

      // Call to GPTService to get the response
      try {
        final gptResponse = await gptService.getResponse(userMessage);
        setState(() {
          messages.add('GPT: $gptResponse');
        });
      } catch (e) {
        setState(() {
          messages.add('Error: Failed to get response.');
          print(e.toString()); // For debugging
        });
      }

      // Auto-scroll to latest message
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 100,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with GPT'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUserMessage = messages[index].startsWith('You:');
                return Container(
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  padding: EdgeInsets.all(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      messages[index],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        labelText: "Type a message",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: CircleAvatar(
                      child: Icon(Icons.send, color: Colors.white),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
