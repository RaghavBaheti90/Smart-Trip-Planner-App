import 'package:flutter/material.dart';
import 'package:smart_trip_planner_app/elements/SavedTripsView.DART';
// import 'package:smart_trip_planner_app/elements/SavedTripsView.dart';

class DemoTokenPage extends StatefulWidget {
  final int token;
  const DemoTokenPage({super.key, required this.token});

  @override
  State<DemoTokenPage> createState() => _DemoTokenPageState();
}

class _DemoTokenPageState extends State<DemoTokenPage> {
  int requestTokensUsed = 0;
  int responseTokensUsed = 0;
  final int maxTokens = 1000;

  double get totalCost {
    // Sample cost estimation (change according to Cohere pricing if needed)
    const double costPerToken = 0.0001;
    return (requestTokensUsed + responseTokensUsed) * costPerToken;
  }

  void updateRequestTokens(int tokens) {
    setState(() {
      requestTokensUsed += tokens;
    });
  }

  void updateResponseTokens(int tokens) {
    setState(() {
      responseTokensUsed += tokens;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFF8F8F8),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: 340,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 20,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.teal,
                        child: Text(
                          'S',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shubham S',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'shubham.s@gmail.com',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  _TokenBar(
                    label: 'Request Tokens',
                    used: requestTokensUsed,
                    max: maxTokens,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 15),
                  _TokenBar(
                    label: 'Response Tokens',
                    used: responseTokensUsed,
                    max: maxTokens,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        'Total Cost',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '\$${totalCost.toStringAsFixed(4)} USD',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 170,
              height: 44,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Add your logout logic here
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // SavedTripsView(),
          ],
        ),
      ),
    );
  }
}

class _TokenBar extends StatelessWidget {
  final String label;
  final int used;
  final int max;
  final Color color;

  const _TokenBar({
    required this.label,
    required this.used,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = (used / max).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Container(
              height: 8,
              width: 285 * percent,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '$used/$max tokens',
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}
