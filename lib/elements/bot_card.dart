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

  @override
  Widget build(BuildContext context) {
    bool showMapTile = text.contains("Mumbai to Bali, Indonesia");
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01,
          horizontal: screenWidth * 0.02,
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
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.018,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(text, style: TextStyle(fontSize: screenWidth * 0.042)),
            SizedBox(height: screenHeight * 0.012),
            if (showMapTile) _buildMapBox(screenWidth, screenHeight),
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

  Widget _buildMapBox(double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.009),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: EdgeInsets.all(screenWidth * 0.025),
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
