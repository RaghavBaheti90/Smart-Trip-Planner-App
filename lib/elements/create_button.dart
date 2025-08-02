import 'package:flutter/material.dart';
import 'package:smart_trip_planner_app/custom/color.dart';
import 'package:smart_trip_planner_app/data/output/output.dart';

class create_button extends StatefulWidget {
  const create_button({super.key});

  @override
  State<create_button> createState() => _create_buttonState();
}

class _create_buttonState extends State<create_button> {
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TripPlannerScreen()),
          );
        },
        child: Text(
          "Create My Itinerary",
          style: TextStyle(fontSize: screenWidth * 0.042, color: Colors.white),
        ),
      ),
    );
  }
}
