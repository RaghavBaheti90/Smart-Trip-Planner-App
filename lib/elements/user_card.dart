import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String text;
  final double screenWidth;
  final double screenHeight;
  const UserCard({
    required this.text,
    required this.screenWidth,
    required this.screenHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  radius: screenWidth * 0.041,
                  child: Text(
                    'S',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  "You",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.008),
            Text(text, style: TextStyle(fontSize: screenWidth * 0.042)),
            SizedBox(height: screenHeight * 0.012),
            Row(
              children: [
                Icon(
                  Icons.copy,
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
}
