import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Title: ${itinerary['title']}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "Start Date: ${itinerary['startDate']}",
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "End Date: ${itinerary['endDate']}",
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(height: 20, thickness: 1.2),
          ...List.generate(days.length, (i) {
            final day = days[i];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Day ${i + 1}: ${day['date']} — ${day['summary']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                ...((day['items'] as List).map<Widget>(
                  (item) => Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 2.0),
                    child: Row(
                      children: [
                        Text(
                          "• ",
                          style: TextStyle(fontSize: 16, color: Colors.teal),
                        ),
                        Expanded(
                          child: Text(
                            "${item['time']}: ${item['activity']} (Location: ${item['location']})",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 12),
              ],
            );
          }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Trip Planner"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: "Enter your trip prompt",
                hintText:
                    "e.g., 5 days in Kyoto next April, solo, mid-range budget",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: Text(_isLoading ? 'Generating...' : 'Generate Itinerary'),
              onPressed: _isLoading
                  ? null
                  : () {
                      final prompt = _promptController.text.trim();
                      if (prompt.isNotEmpty) {
                        _generateItinerary(prompt);
                      }
                    },
            ),
            const SizedBox(height: 18),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _itinerary == null
                  ? const SizedBox.shrink()
                  : _buildItineraryView(_itinerary!),
            ),
            const SizedBox(height: 14),
            Text(
              '🧠 Estimated Tokens Used: $_estimatedTokensUsed',
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
