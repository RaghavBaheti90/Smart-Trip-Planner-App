import 'package:flutter/material.dart';

class BotCard extends StatelessWidget {
  final String text;
  final double screenWidth;
  final double screenHeight;
  const BotCard({
    required this.text,
    required this.screenWidth,
    required this.screenHeight,
    Key? key,
  }) : super(key: key);

  // Helper: Builds a RichText widget parsing the input text for Days and Time labels
  Widget _buildFormattedText(String text, double screenWidth) {
    final lines = text.split('\n');
    const timeLabels = ['Morning', 'Afternoon', 'Evening', 'Night'];

    List<InlineSpan> spans = [];

    for (final line in lines) {
      final trimmed = line.trimLeft();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('Day')) {
        // Day heading bold
        spans.add(
          TextSpan(
            text: trimmed + '\n',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.045,
              color: Colors.black,
            ),
          ),
        );
      } else if (trimmed.startsWith('•')) {
        // Bullet point processing for Time labels
        bool foundLabel = false;

        for (var label in timeLabels) {
          if (trimmed.startsWith('• $label:')) {
            spans.add(
              TextSpan(
                text: "  • ",
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  color: Colors.black,
                ),
              ),
            );
            spans.add(
              TextSpan(
                text: '$label:',
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            );
            final remainder = trimmed.substring(('• $label:').length);
            spans.add(
              TextSpan(
                text: remainder + '\n',
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  color: Colors.black,
                ),
              ),
            );
            foundLabel = true;
            break;
          }
        }

        if (!foundLabel) {
          // Normal bullet point indented
          spans.add(
            TextSpan(
              text: "    $trimmed\n",
              style: TextStyle(
                fontSize: screenWidth * 0.042,
                color: Colors.black87,
              ),
            ),
          );
        }
      } else {
        // Plain text lines fallback
        spans.add(
          TextSpan(
            text: trimmed + '\n',
            style: TextStyle(
              fontSize: screenWidth * 0.042,
              color: Colors.black87,
            ),
          ),
        );
      }
    }
    return RichText(text: TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    final showMapTile = text.contains("Mumbai") || text.contains("Indonesia");

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01,
          horizontal: screenWidth * 0.02,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.018,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: screenWidth * 0.016,
              offset: Offset(0, screenHeight * 0.003),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange[100],
                  radius: screenWidth * 0.041,
                  child: Icon(
                    Icons.brightness_low,
                    color: Colors.orange[800],
                    size: screenWidth * 0.05,
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  "Itinera AI",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.008),

            // Formatted text output
            _buildFormattedText(text, screenWidth),

            SizedBox(height: screenHeight * 0.012),

            if (showMapTile) _buildMapBox(screenWidth, screenHeight),

            // Action icons
            Row(
              children: [
                Icon(
                  Icons.copy,
                  size: screenWidth * 0.04,
                  color: Colors.grey.shade700,
                ),
                SizedBox(width: screenWidth * 0.025),
                Icon(
                  Icons.download_outlined,
                  size: screenWidth * 0.04,
                  color: Colors.grey.shade700,
                ),
                SizedBox(width: screenWidth * 0.025),
                Icon(
                  Icons.autorenew,
                  size: screenWidth * 0.04,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Map panel widget as before
  Widget _buildMapBox(double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.009),
      padding: EdgeInsets.all(screenWidth * 0.025),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on, color: Colors.red, size: screenWidth * 0.045),
          SizedBox(width: screenWidth * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Open in maps",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: screenWidth * 0.034,
                  ),
                ),
                SizedBox(height: screenHeight * 0.003),
                Text(
                  "Mumbai to Bali, Indonesia | 11hrs 5mins",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: screenWidth * 0.034,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
