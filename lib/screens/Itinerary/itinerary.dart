import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/classes/itinerary.dart';
import 'package:test_app/components/customcard.dart';
import 'package:test_app/components/itineraryblock.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/sampledata/people.dart';
import 'package:test_app/screens/Itinerary/createitinerary.dart';
import 'package:test_app/utility/firebaseutils.dart';
import 'package:test_app/utility/globals.dart';
import 'package:test_app/components/custom_fab.dart';

const currentUser = SamplePeople.muthu;

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});
  @override
  ItineraryScreenState createState() => ItineraryScreenState();
}

class ItineraryScreenState extends State<ItineraryScreen> {
  List<Group> groups = [];
  List<Itinerary> itineraries = [];
  Map<String, List<Itinerary>> groupedData = {};
  bool hasLoaded = false;

  @override
  void initState() {
    hasLoaded = false;
    super.initState();
    if (globalGroup != "NULL") {
      FirebaseUtils.fetchItinerariesByGroupId(globalGroup)
          .then((fetchedItineraries) {
        setState(() {
          itineraries = fetchedItineraries;
        });
      });
    }
    FirebaseUtils.fetchGroupsByUserId(globalUser.id, false)
        .then((fetchedGroups) {
      setState(() {
        groups = fetchedGroups;
        hasLoaded = true;
      });
    });
  }

  int compareItineraries(Itinerary a, Itinerary b) {
    // First, compare dates
    int dateComparison = a.date.compareTo(b.date);
    if (dateComparison != 0) {
      return dateComparison;
    }
    // If dates are the same, compare start times
    return a.startTime.compareTo(b.startTime);
  }

  @override
  Widget build(BuildContext context) {
    if (globalGroup == "NULL") {
      return const Scaffold(
        body: Center(
          child: Text("Please create and select a group\n"),
        ),
      );
    }
    groupedData = {};
    for (var entry in itineraries) {
      DateTime date = DateTime.parse(entry.date);
      if (date.isAfter(DateTime.now()) ||
          date.isAtSameMomentAs(DateTime.now())) {
        String yearMonthDay = DateFormat('yyyy-MM-dd').format(date);
        if (!groupedData.containsKey(yearMonthDay)) {
          groupedData[yearMonthDay] = [];
        }
        groupedData[yearMonthDay]!.add(entry);
      }
    }

    for (var key in groupedData.keys) {
      groupedData[key]!.sort(compareItineraries);
    }

    // Now, if you want to sort groupedData keys based on date, you can create a list of keys and sort them
    List<String> sortedKeys = groupedData.keys.toList()
      ..sort((a, b) => DateTime.parse(a).compareTo(DateTime.parse(b)));

    // Create a new map with sorted keys
    Map<String, List<Itinerary>> sortedGroupedData = Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, groupedData[key]!)),
    );

    return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100),
          child: Column(children: <Widget>[
            const CustomCard(),
            Column(
              children: sortedGroupedData.entries
                  .map((e) => ItineraryBlock(day: e.key, group: e.value))
                  .toList(),
            )
          ]),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomSizedFloatingActionButton(
              heroTag: 'add-itinerary-button',
              elevation: 12.0,
              backgroundColor: const Color(Colours.PRIMARY),
              onPressed: !hasLoaded
                  ? null
                  : () async {
                      final Itinerary? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateItinerary(
                                  groups: groups,
                                  creator: globalUser.id,
                                )),
                      );
                      if (result != null) {
                        setState(() => itineraries.add(result));
                        FirebaseUtils.uploadData("itinerary", {
                          "date": result.date,
                          "startTime": result.startTime,
                          "endTime": result.endTime,
                          "activity": result.activity,
                          "creator": globalUser.id,
                          "people": result.people,
                          "group": globalGroup
                        }).then((_) {
                          // Fetch the latest data again after adding a new expenditure
                          FirebaseUtils.fetchItinerariesByGroupId(globalGroup)
                              .then((fetchedItineraries) {
                            setState(() {
                              itineraries = fetchedItineraries;
                            });
                          });

                          FirebaseUtils.fetchGroupsByUserId(
                                  globalUser.id, false)
                              .then((fetchedGroups) {
                            setState(() {
                              groups = fetchedGroups;
                              hasLoaded = true;
                            });
                          });
                        });
                        String groupId = result.group;
                        // await FirebaseUtils.updateGroupItinerary(
                        //     groupId, globalUser.id, result.amount);
                      } else {
                        print("NO");
                      }
                    },
              icon: const Icon(Icons.add, color: Color(Colours.WHITECONTRAST)),
            )
          ],
        ));
  }
}
