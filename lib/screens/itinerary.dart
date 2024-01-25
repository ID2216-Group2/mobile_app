import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/components/customcard.dart';
import 'package:test_app/components/itineraryblock.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/constants/categories.dart';
import 'package:test_app/sampledata/people.dart';
import 'package:test_app/classes/itinerary.dart';
import 'package:test_app/screens/createitinerary.dart';

const currentUser = SamplePeople.muthu;

const sampleGroup = [SamplePeople.muthu, SamplePeople.ali, SamplePeople.bob];

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});
  @override
  ItineraryScreenState createState() => ItineraryScreenState();
}

class ItineraryScreenState extends State<ItineraryScreen> {
  List<Itinerary> sampleData = [
    Itinerary(
        date: "2024-01-24",
        activity: "Museum",
        startTime: TimeOfDay(hour: 3, minute: 30),
        endTime: TimeOfDay(hour: 6, minute: 30),
        people: [SamplePeople.ali, SamplePeople.bob, SamplePeople.muthu],
        creator: SamplePeople.muthu),
    Itinerary(
        date: "2024-01-10",
        activity: "Kajsas Fisk",
        startTime: TimeOfDay(hour: 3, minute: 00),
        endTime: TimeOfDay(hour: 4, minute: 30),
        people: [SamplePeople.bob, SamplePeople.muthu],
        creator: SamplePeople.muthu),
    Itinerary(
        date: "2024-01-02",
        activity: "Ski",
        startTime: TimeOfDay(hour: 1, minute: 30),
        endTime: TimeOfDay(hour: 5, minute: 30),
        people: [SamplePeople.bob, SamplePeople.ali],
        creator: SamplePeople.ali)
  ];
  Map<String, List<Itinerary>> groupedData = {};

  @override
  Widget build(BuildContext context) {
    groupedData = {};
    for (var entry in sampleData) {
      DateTime date = DateTime.parse(entry.date);
      String yearMonthDate = DateFormat('yyyy-MM-DD').format(date);

      if (!groupedData.containsKey(yearMonthDate)) {
        groupedData[yearMonthDate] = [];
      }
      groupedData[yearMonthDate]!.add(entry);
    }
    return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100),
          child: Column(children: <Widget>[
            const CustomCard(),
            Column(
              children: groupedData.entries
                  .map((e) => ItineraryBlock(day: e.key, group: e.value))
                  .toList(),
            )
          ]),
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 12.0,
          backgroundColor: const Color(Colours.PRIMARY),
          onPressed: () async {
            final Itinerary? result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateItinerary(
                        group: sampleGroup,
                        creator: SamplePeople.muthu,
                      )),
            );
            if (result != null) {
              setState(() => sampleData.add(result));
              print(result.date);
              print(result.startTime);
              print(result.endTime);
              print(result.activity);
              print(result.creator);
              print(result.people);
            } else {
              print("NO");
            }
          },
          icon: const Icon(Icons.edit, color: Color(Colours.WHITECONTRAST)),
          label: const Text("Add Itinerary",
              style: TextStyle(color: Color(Colours.WHITECONTRAST))),
        ));
  }
}

