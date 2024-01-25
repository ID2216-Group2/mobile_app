import 'package:flutter/material.dart';
import 'package:test_app/classes/itinerary.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/components/itinerarytile.dart';
import 'package:test_app/sampledata/people.dart';

class ItineraryBlock extends StatelessWidget {
  const ItineraryBlock(
      {super.key, this.day = "2000-01-01", this.group = const []});
  final String day;
  final List<Itinerary> group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              alignment: Alignment.centerLeft,
              color: Color(Colours.SECONDARY),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(day,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)),
              ),
            ),
          ),
          ...group.map(
            (itinerary) => ItineraryTile(
              activity: itinerary.activity,
              startTime: itinerary.startTime,
              endTime: itinerary.endTime,
            ),
          )
        ],
      ),
    );
  }
}
