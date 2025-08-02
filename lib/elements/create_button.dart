import 'package:flutter/material.dart';
import 'package:smart_trip_planner_app/custom/color.dart';
import 'package:smart_trip_planner_app/data/output/output.dart';

class CreateButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CreateButton({super.key, required this.onPressed});

  @override
  State<CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.06,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
        ),
        onPressed: widget.onPressed,
        child: Text(
          "Create My Itinerary",
          style: TextStyle(fontSize: screenWidth * 0.042, color: Colors.white),
        ),
      ),
    );
  }
}
