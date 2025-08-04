import 'package:flutter/material.dart';
import 'package:smart_trip_planner_app/custom/color.dart';

class InputBar extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final TextEditingController controller;
  final bool isLoading;
  final Function({String? input}) onSend;

  const InputBar({
    required this.screenWidth,
    required this.screenHeight,
    required this.controller,
    required this.isLoading,
    required this.onSend,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, screenHeight * 0.01),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.025,
          vertical: screenHeight * 0.006,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.06),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Follow up to refine",
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: screenWidth * 0.042),
                ),
                onSubmitted: (_) => onSend(),
                enabled: !isLoading,
                style: TextStyle(fontSize: screenWidth * 0.042),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: screenWidth * 0.06,
                ),
                onPressed: () => onSend(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
