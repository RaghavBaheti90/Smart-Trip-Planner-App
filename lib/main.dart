import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_trip_planner_app/screens/home_page.dart';
import 'package:smart_trip_planner_app/screens/login_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('tripBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TripPlannerScreen(),
    );
  }
}
