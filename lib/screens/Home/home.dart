import 'package:flutter/material.dart';
import 'package:test_app/classes/itinerary.dart';
import 'package:test_app/screens/Home/components/ItineraryItem.dart';
import 'package:test_app/utility/firebaseutils.dart';
import 'package:test_app/utility/globals.dart';

class HomeScreenState extends State<HomeScreen> {
  List<Itinerary> itineraries = [];
  bool hasLoaded = false;

  @override
  void initState() {
    hasLoaded = false;
    super.initState();
    FirebaseUtils.fetchTodayItinerariesByUserId(globalUser.id)
      .then((fetchedItineraries) => {
        setState(() {
          itineraries = fetchedItineraries;
          hasLoaded = true;
        })
      });
  }

  @override
  Widget build(BuildContext context) {
    if (!hasLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (itineraries.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("No activities planned for today :(\n"),
        ),
      );
    } else {
      return Scaffold(
        body: ListView.builder(
          itemCount: itineraries.length,
          itemBuilder: (context, index) {
            Itinerary it = itineraries[index];
            return ItineraryItem(
              startTime: it.startTime, 
              endTime: it.endTime, 
              activity: it.activity,
              groupId: it.group,
              idx: index,
            );
          }
        ),
      );
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}