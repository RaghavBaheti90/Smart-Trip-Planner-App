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
      child: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.13,
          top: screenHeight * 0.025,
          bottom: screenHeight * 0.016,
        ),
        child: Row(
          children: [
            SizedBox(
              height: screenWidth * 0.042,
              width: screenWidth * 0.042,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: screenWidth * 0.024),
            Text(
              "Planning...",
              style: TextStyle(
                color: Colors.black54,
                fontSize: screenWidth * 0.036,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
