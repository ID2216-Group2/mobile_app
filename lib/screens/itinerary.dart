import 'package:flutter/material.dart';

class Itinerary extends StatefulWidget {
  @override
  ItineraryState createState() => ItineraryState();
}

class ItineraryState extends State<Itinerary> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Itinerary'),
          SizedBox(height: 10),
        ],
      )),
    );
  }
}
