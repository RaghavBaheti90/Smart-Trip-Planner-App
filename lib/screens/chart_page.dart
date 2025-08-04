import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:smart_trip_planner_app/custom/color.dart';
import 'package:smart_trip_planner_app/elements/bot_card.dart';
import 'package:smart_trip_planner_app/elements/bot_thinking.dart';
import 'package:smart_trip_planner_app/elements/input_bar.dart';
import 'package:smart_trip_planner_app/elements/user_card.dart';

class ItineraryChatPage extends StatefulWidget {
  final String initialPrompt;
  const ItineraryChatPage({Key? key, required this.initialPrompt})
    : super(key: key);

  @override
  State<ItineraryChatPage> createState() => _ItineraryChatPageState();
}

class _ItineraryChatPageState extends State<ItineraryChatPage> {
  final List<Message> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  late Box tripBox;

  static const String _apiKey = 'iuAfB9KCbgyGauQS23mDHrEudiSINa7EX8errPlP';
  static const String _endpoint = 'https://api.cohere.ai/v1/chat';

  @override
  void initState() {
    super.initState();
    tripBox = Hive.box('tripBox'); // Make sure box is already opened in main()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendMessage(input: widget.initialPrompt);
    });
  }

  Future<void> _sendMessage({String? input}) async {
    final messageText = input?.trim() ?? _inputController.text.trim();
    if (messageText.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(Message(sender: Sender.user, text: messageText));
      if (input == null) _inputController.clear();
      _isLoading = true;
      _error = null;
    });

    final chatHistory = _messages
        .map(
          (m) => {
            "role": m.sender == Sender.user ? "USER" : "CHATBOT",
            "message": m.text,
          },
        )
        .toList();

    final systemPrompt = '''
You are an expert itinerary assistant.
- Always return the entire multi-day plan after any user message.
- Group each day's plan as:

Day 1:
  Morning: <activities, locations>
  Afternoon: <activities, locations>
  Evening: <activities, locations>
  Night: <activities, locations>

Label activities clearly using times of day (Morning, Afternoon, Evening, Night).
When a user asks for a change (e.g., "Add tea party on day 4 afternoon"), edit and show the whole new plan in the same style.
Do not add extra explanations. Only show the new full itinerary.
''';

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
          _messages.add(Message(sender: Sender.bot, text: reply));
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

  Future<void> _saveLastTrip() async {
    try {
      final lastBotMessage = _messages.lastWhere(
        (msg) => msg.sender == Sender.bot,
        orElse: () => Message(sender: Sender.bot, text: ''),
      );
      if (lastBotMessage.text.isNotEmpty) {
        await tripBox.put('lastTrip', lastBotMessage.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip saved successfully')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No trip to save')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving trip: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Itinerary Chat',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: screenWidth * 0.05,
          ),
        ),
        leading: const BackButton(color: Colors.black),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04),
            child: CircleAvatar(
              radius: screenWidth * 0.046,
              child: Icon(
                Icons.person,
                size: screenWidth * 0.045,
                color: const Color.fromARGB(255, 16, 11, 11),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(screenWidth * 0.025),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, i) {
                if (_isLoading && i == 0) {
                  return BotThinking(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  );
                }
                final msg =
                    _messages[_messages.length -
                        1 -
                        (i - (_isLoading ? 1 : 0))];
                return msg.sender == Sender.user
                    ? UserCard(
                        text: msg.text,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      )
                    : BotCard(
                        text: msg.text,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      );
              },
            ),
          ),
          if (_error != null)
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.025),
              child: Text(
                _error!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenWidth * 0.01,
            ),
            child: ElevatedButton.icon(
              onPressed: _saveLastTrip,
              icon: const Icon(Icons.save_alt_outlined, color: Colors.white),
              label: const Text('Save Trip'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: AppColors.primary, // Use team color
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          InputBar(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            controller: _inputController,
            isLoading: _isLoading,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

enum Sender { user, bot }

class Message {
  final Sender sender;
  final String text;
  Message({required this.sender, required this.text});
}
