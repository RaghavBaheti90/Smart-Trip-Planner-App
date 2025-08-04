import 'package:flutter/material.dart';

class BotThinking extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const BotThinking({
    required this.screenWidth,
    required this.screenHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01,
          horizontal: screenWidth * 0.02,
        ),
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.025,
          horizontal: screenWidth * 0.05,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange[100],
                  radius: screenWidth * 0.034,
                  child: Icon(
                    Icons.chat_bubble,
                    color: Colors.orange[800],
                    size: screenWidth * 0.038,
                  ),
                ),
                SizedBox(width: screenWidth * 0.025),
                Text(
                  "Itinera AI",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: screenWidth * 0.042,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.018),
            Row(
              children: [
                Container(
                  width: screenWidth * 0.045,
                  height: screenWidth * 0.045,
                  padding: EdgeInsets.all(2),
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                SizedBox(width: screenWidth * 0.022),
                Text(
                  "Thinking...",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
