import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SavedTripsPage extends StatefulWidget {
  const SavedTripsPage({Key? key}) : super(key: key);

  @override
  _SavedTripsPageState createState() => _SavedTripsPageState();
}

class _SavedTripsPageState extends State<SavedTripsPage> {
  late Box tripBox;
  List<Map> savedTrips = [];

  @override
  void initState() {
    super.initState();
    tripBox = Hive.box('tripBox');
    loadTrips();
  }

  void loadTrips() {
    final trips = tripBox.get('trips', defaultValue: <Map>[])?.cast<Map>() ?? [];
    setState(() {
      savedTrips = trips;
    });
  }

  void deleteTrip(int index) async {
    savedTrips.removeAt(index);
    await tripBox.put('trips', savedTrips);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (savedTrips.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Trips'),
        ),
        body: const Center(child: Text('No saved trips yet.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Trips'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: savedTrips.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final trip = savedTrips[index];
          final title = trip['title'] ?? 'Untitled Trip';
          final start = trip['startDate'] ?? 'Unknown Start';
          final end = trip['endDate'] ?? 'Unknown End';
          return ListTile(
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('$start to $end'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteTrip(index),
            ),
            onTap: () {
              
            },
          );
        },
      ),
    );
  }
}
