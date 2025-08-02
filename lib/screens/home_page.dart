import 'package:flutter/material.dart';
import 'package:smart_trip_planner_app/custom/color.dart';
import 'package:smart_trip_planner_app/elements/create_button.dart';
import 'package:smart_trip_planner_app/elements/fill_box.dart';

void main() {
  runApp(
    MaterialApp(home: TripPlannerHomePage(), debugShowCheckedModeBanner: false),
  );
}

class TripPlannerHomePage extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.025,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Row
              Row(
                children: [
                  Text(
                    "Hey Shubham 👋",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  CircleAvatar(
                    radius: screenWidth * 0.055,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      "S",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.044,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),

              // Title
              Text(
                "What's your vision\nfor this trip?",
                style: TextStyle(
                  fontSize: screenWidth * 0.065,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // "Vision" TextField box
              fill_box(onSubmit: (value) {}),
              SizedBox(height: screenHeight * 0.025),

              // "Create My Itinerary" Button
              create_button(),
              SizedBox(height: screenHeight * 0.03),

              // "Offline Saved Itineraries"
              Text(
                "Offline Saved Itineraries",
                style: TextStyle(
                  fontSize: screenWidth * 0.046,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.014),

              // List of saved itineraries
              Expanded(
                child: ListView(
                  children: [
                    itineraryListItem(
                      "Japan Trip, 20 days vaccation, explore ky...",
                      screenWidth,
                    ),
                    itineraryListItem(
                      "India Trip, 7 days work trip, suggest affo...",
                      screenWidth,
                    ),
                    itineraryListItem(
                      "Europe trip, include Paris, Berlin, Dortmun...",
                      screenWidth,
                    ),
                    itineraryListItem(
                      "Two days weekend getaway to somewhe...",
                      screenWidth,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itineraryListItem(String title, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: ListTile(
        leading: Icon(
          Icons.circle,
          size: screenWidth * 0.03,
          color: Colors.teal,
        ),
        title: Text(
          title,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: screenWidth * 0.037,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          // Handle tap if needed
        },
      ),
    );
  }
}
