import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_trip_planner_app/custom/color.dart';
import 'package:smart_trip_planner_app/elements/SavedTripsView.dart';
import 'package:smart_trip_planner_app/elements/fill_box.dart';
import 'package:smart_trip_planner_app/elements/create_button.dart';
import 'package:smart_trip_planner_app/elements/itinerary_view.dart';
import 'package:smart_trip_planner_app/screens/chart_page.dart';
import 'package:smart_trip_planner_app/screens/token_screen.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  final TextEditingController _promptController = TextEditingController();
  Map<String, dynamic>? _itinerary;
  bool _isLoading = false;
  int _estimatedTokensUsed = 0;
  String? _error;

  static const String _apiKey = 'iuAfB9KCbgyGauQS23mDHrEudiSINa7EX8errPlP';

  int _estimateTokens(String text) => (text.length / 4).ceil();

  Future<void> _generateItinerary(String prompt) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _itinerary = null;
      _estimatedTokensUsed = 0;
    });

    const String endpoint = 'https://api.cohere.ai/v1/chat';

    final String structuredPrompt =
        '''
You are an advanced travel assistant.
Based on the TRIP DESCRIPTION below, generate a complete, valid JSON itinerary in this EXACT format (do not include any explanation or extra text):

{
  "title": "",
  "startDate": "",
  "endDate": "",
  "days": [
    {
      "date": "",
      "summary": "",
      "items": [
        { "time": "", "activity": "", "location": "" }
      ]
    }
  ]
}

TRIP DESCRIPTION: $prompt
''';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "command-r-plus",
          "temperature": 0.5,
          "chat_history": [],
          "message": structuredPrompt,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final text = jsonData['text'] ?? '';

        final promptTokens = _estimateTokens(structuredPrompt);
        final responseTokens = _estimateTokens(text);
        final totalTokens = promptTokens + responseTokens;

        final jsonStart = text.indexOf('{');
        final jsonEnd = text.lastIndexOf('}');
        if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
          final jsonStr = text.substring(jsonStart, jsonEnd + 1);
          try {
            final itinerary = jsonDecode(jsonStr);
            setState(() {
              _itinerary = itinerary;
              _estimatedTokensUsed = totalTokens;
            });
          } catch (e) {
            setState(() {
              _error =
                  '⚠️ Prompt is not understood. Please rewrite the prompt and try again.';
              _estimatedTokensUsed = totalTokens;
            });
          }
        } else {
          setState(() {
            _error =
                '⚠️ JSON format not found in response.\n\nRaw output:\n$text';
            _estimatedTokensUsed = totalTokens;
          });
        }
      } else {
        setState(() {
          _error = 'HTTP Error ${response.statusCode}: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Exception: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.025,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Hey User 👋",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              // SavedTripsPage(),
                              DemoTokenPage(token: _estimatedTokensUsed),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: screenWidth * 0.055,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: screenWidth * 0.055,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              Text(
                "What's your vision\nfor this trip?",
                style: TextStyle(
                  fontSize: screenWidth * 0.065,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              _itinerary == null
                  ? fill_box(
                      controller: _promptController,
                      onSubmit: (value) {
                        if (value.trim().isNotEmpty) {
                          _generateItinerary(value.trim());
                        }
                      },
                    )
                  : ItineraryView(itinerary: _itinerary!),
              SizedBox(height: screenHeight * 0.025),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _itinerary == null
                  ? CreateButton(
                      Text: "Create My Itinerary",
                      onPressed: () {
                        final prompt = _promptController.text.trim();
                        if (prompt.isNotEmpty) {
                          _generateItinerary(prompt);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter your trip vision.'),
                            ),
                          );
                        }
                      },
                    )
                  : CreateButton(
                      Text: "Follow up to refine",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItineraryChatPage(
                              initialPrompt: _promptController.text,
                            ),
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 18),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              Text(
                '🧠 Estimated Tokens Used: $_estimatedTokensUsed',
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
