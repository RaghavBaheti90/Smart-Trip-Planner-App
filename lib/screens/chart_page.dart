import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CohereChatPage extends StatefulWidget {
  final String initialPrompt;

  const CohereChatPage({Key? key, required this.initialPrompt})
    : super(key: key);

  @override
  _CohereChatPageState createState() => _CohereChatPageState();
}

class _CohereChatPageState extends State<CohereChatPage> {
  final List<_Message> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  static const String _apiKey = 'iuAfB9KCbgyGauQS23mDHrEudiSINa7EX8errPlP';
  static const String _endpoint = 'https://api.cohere.ai/v1/chat';

  @override
  void initState() {
    super.initState();

    // Automatically send the initial prompt on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendMessage(input: widget.initialPrompt);
    });
  }

  Future<void> _sendMessage({String? input}) async {
    final messageText = input?.trim() ?? _inputController.text.trim();
    if (messageText.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(_Message(sender: Sender.user, text: messageText));
      if (input == null) {
        // Only clear controller for user-typed input (not initialPrompt)
        _inputController.clear();
      }
      _isLoading = true;
      _error = null;
    });

    // Build chat history for API
    final chatHistory = _messages
        .map(
          (m) => {
            "role": m.sender == Sender.user ? "USER" : "CHATBOT",
            "message": m.text,
          },
        )
        .toList();

    // The assistant's system prompt
    final systemPrompt =
        'You are an intelligent, helpful assistant. Reply conversationally to the user.';

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "command-r-plus",
          "temperature": 0.5,
          "chat_history": chatHistory,
          "message": systemPrompt,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['text'] ?? '[No response]';
        setState(() {
          _messages.add(_Message(sender: Sender.bot, text: reply));
        });
      } else {
        setState(() {
          _error = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cohere ChatBot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, i) {
                if (_isLoading && i == 0) return _buildBotThinking();
                final msg =
                    _messages[_messages.length -
                        1 -
                        (i - (_isLoading ? 1 : 0))];
                return msg.sender == Sender.user
                    ? _buildUserBubble(msg.text)
                    : _buildBotBubble(msg.text);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 10),
            ),
          ),
          const Divider(height: 1),
          _buildInputBar(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  Widget _buildUserBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildBotBubble(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                hintText: "Type your message...",
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _sendMessage(),
              enabled: !_isLoading,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildBotThinking() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: const [
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text("Thinking..."),
        ],
      ),
    );
  }
}

enum Sender { user, bot }

class _Message {
  final Sender sender;
  final String text;
  _Message({required this.sender, required this.text});
}
