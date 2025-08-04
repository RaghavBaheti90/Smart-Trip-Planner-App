import 'package:flutter/material.dart';

class ItineraryChatPage extends StatelessWidget {
  final String initialPrompt;
  const ItineraryChatPage({Key? key, required this.initialPrompt})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Your chat page code here
    return Scaffold(
      appBar: AppBar(title: Text('Itinerary Chat')),
      body: Center(child: Text('Chat for: $initialPrompt')),
    );
  }
}
