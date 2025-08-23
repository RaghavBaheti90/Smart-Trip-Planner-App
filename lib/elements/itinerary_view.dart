import 'package:flutter/material.dart';
import 'package:smart_trip_planner_app/custom/color.dart';

class ItineraryView extends StatelessWidget {
  final Map<String, dynamic> itinerary;

  const ItineraryView({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    final days = itinerary['days'] as List<dynamic>? ?? [];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final base = screenWidth * 0.04;
    final verticalPadding = screenHeight * 0.02;
    final horizontalPadding = screenWidth * 0.04;

    return Expanded(
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(base * 1.1),
            border: Border.all(color: Colors.teal.shade100, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                itinerary['title'] ?? '',
                style: TextStyle(
                  fontSize: base * 1.2,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(height: base * 0.6),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: base,
                    color: AppColors.secondary,
                  ),
                  SizedBox(width: base * 0.2),
                  Text(
                    "Start: ${itinerary['startDate'] ?? ''}",
                    style: TextStyle(fontSize: base),
                  ),
                  SizedBox(width: base * 0.7),
                  Icon(Icons.flag, size: base, color: AppColors.secondary),
                  SizedBox(width: base * 0.2),
                  Text(
                    "End: ${itinerary['endDate'] ?? ''}",
                    style: TextStyle(fontSize: base),
                  ),
                ],
              ),
              Divider(height: base * 1.5),
              ...List.generate(days.length, (i) {
                final day = days[i];
                return Container(
                  margin: EdgeInsets.only(bottom: base * 0.8, top: base * 0.25),
                  padding: EdgeInsets.all(base * 0.5),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(base * 0.6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Day ${i + 1}: ${day['date']} - ${day['summary']}",
                        style: TextStyle(
                          fontSize: base * 1.06,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      SizedBox(height: base * 0.15),
                      ...List.generate((day['items'] as List).length, (j) {
                        final item = day['items'][j];
                        return Padding(
                          padding: EdgeInsets.only(
                            left: base * 0.7,
                            bottom: base * 0.26,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: base * 0.36,
                                color: Colors.teal.shade300,
                              ),
                              SizedBox(width: base * 0.3),
                              Expanded(
                                child: Text(
                                  "${item['time']}: ${item['activity']} (Location: ${item['location']})",
                                  style: TextStyle(fontSize: base * 0.96),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
