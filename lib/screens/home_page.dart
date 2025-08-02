import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_trip_planner_app/custom/color.dart';
import 'package:smart_trip_planner_app/elements/create_button.dart';
import 'package:smart_trip_planner_app/elements/fill_box.dart';

void main() {
  runApp(
    const MaterialApp(
      home: TripPlannerHomePage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class TripPlannerHomePage extends StatefulWidget {
  const TripPlannerHomePage({super.key});

  @override
  State<TripPlannerHomePage> createState() => _TripPlannerHomePageState();
}

class _TripPlannerHomePageState extends State<TripPlannerHomePage> {
  final TextEditingController _promptController = TextEditingController();
  Map<String, dynamic>? _itinerary;
  bool _isLoading = false;
  String? _error;
  int _estimatedTokensUsed = 0;

  static const String _apiKey = 'iuAfB9KCbgyGauQS23mDHrEudiSINa7EX8errPlP';

  int _estimateTokens(String text) => (text.length / 4).ceil();

  Future<void> _generateItinerary(String prompt) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _itinerary = null;
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
              _estimatedTokensUsed += totalTokens;
            });
          } catch (e) {
            setState(() {
              _error = '⚠️ Failed to parse JSON: $e\n\nRaw output:\n$text';
              _estimatedTokensUsed += totalTokens;
            });
          }
        } else {
          setState(() {
            _error =
                '⚠️ JSON format not found in response.\n\nRaw output:\n$text';
            _estimatedTokensUsed += totalTokens;
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

  Widget _buildItineraryView(Map<String, dynamic> itinerary) {
    final days = itinerary['days'] as List<dynamic>;
    return Expanded(
      child: ListView(
        children: [
          Text(
            "Title: ${itinerary['title']}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Start Date: ${itinerary['startDate']}",
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "End Date: ${itinerary['endDate']}",
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(),
          ...List.generate(days.length, (i) {
            final day = days[i];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Day ${i + 1}: ${day['date']} - ${day['summary']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...List.generate((day['items'] as List).length, (j) {
                  final item = day['items'][j];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                    child: Text(
                      "• ${item['time']}: ${item['activity']} (Location: ${item['location']})",
                    ),
                  );
                }),
                const SizedBox(height: 12),
              ],
            );
          }),
        ],
      ),
    );
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
                    "Hey Shubham 👋",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: screenWidth * 0.055,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      "S",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.044,
                        fontWeight: FontWeight.w600,
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
              fill_box(
                controller: _promptController,
                onSubmit: (value) {
                  _generateItinerary(value);
                },
              ),
              SizedBox(height: screenHeight * 0.025),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CreateButton(
                      onPressed: () {
                        final prompt = _promptController.text.trim();
                        if (prompt.isNotEmpty) _generateItinerary(prompt);
                      },
                    ),

              const SizedBox(height: 18),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              if (_itinerary != null) _buildItineraryView(_itinerary!),
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
