import 'package:flutter/material.dart';
import 'package:smart_trip_planner_app/custom/color.dart';

class fill_box extends StatefulWidget {
  final TextEditingController controller;
  const fill_box({
    super.key,
    required this.controller,
    required Null Function(dynamic visionText) onSubmit,
  });

  @override
  State<fill_box> createState() => _fill_boxState();
}

class _fill_boxState extends State<fill_box> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(color: Colors.green.shade200),
      ),
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Your Request!",
              ),
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
          ),
          Icon(Icons.mic, color: AppColors.primary, size: screenWidth * 0.06),
        ],
      ),
    );
  }
}
