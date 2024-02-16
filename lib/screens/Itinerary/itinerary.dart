// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:test_app/components/customcard.dart';
// import 'package:test_app/components/itineraryblock.dart';
// import 'package:test_app/constants/colours.dart';
// import 'package:test_app/constants/categories.dart';
// import 'package:test_app/sampledata/people.dart';
// import 'package:test_app/classes/itinerary.dart';
// import 'package:test_app/screens/Itinerary/addGroup.dart';
// import 'package:test_app/screens/Itinerary/createitinerary.dart';
// import 'package:test_app/screens/SideGroup/components/creategroup.dart';
// import 'package:test_app/utility/firebaseutils.dart';
// import 'package:test_app/utility/globals.dart';

// const currentUser = SamplePeople.muthu;

// const sampleGroup = [SamplePeople.muthu, SamplePeople.ali, SamplePeople.bob];

// class ItineraryScreen extends StatefulWidget {
//   const ItineraryScreen({super.key});
//   @override
//   ItineraryScreenState createState() => ItineraryScreenState();
// }

// class ItineraryScreenState extends State<ItineraryScreen> {
//   List<Itinerary> itineraries = [];
//   List<dynamic> allUsers = [];
//   Map<String, List<Itinerary>> groupedData = {};
//   bool hasLoaded = false;

//   @override
//   void initState() {
//     hasLoaded = false;
//     super.initState();
//     FirebaseUtils.retrieveCollection("users")
//         .then((AllUsers) {
//       setState(() {
//         allUsers = AllUsers;
//       });
//     });
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     groupedData = {};
//     // for (var entry in sampleData) {
//     //   DateTime date = DateTime.parse(entry.date);
//     //   String yearMonthDate = DateFormat('yyyy-MM-DD').format(date);

//     //   if (!groupedData.containsKey(yearMonthDate)) {
//     //     groupedData[yearMonthDate] = [];
//     //   }
//     //   groupedData[yearMonthDate]!.add(entry);
//     // }
//     return Scaffold(
//         body: SingleChildScrollView(
//           padding: EdgeInsets.only(bottom: 100),
//           child: Column(children: <Widget>[
//             const CustomCard(),
//             Column(
//               children: groupedData.entries
//                   .map((e) => ItineraryBlock(day: e.key, group: e.value))
//                   .toList(),
//             )
//           ]),
//         ),
        

        
//         floatingActionButton: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             // FloatingActionButton.extended(
//             //   onPressed:(){Navigator.push(
//             //     context,
//             //     MaterialPageRoute(builder: (context) => const AddGroup()),
//             //   );},
//             //   label: const Text("Add Travel Group")
//             // ),
            
//             FloatingActionButton.extended(
//             elevation: 12.0,
//             backgroundColor: const Color(Colours.PRIMARY),
//             onPressed: () async {
//               final Itinerary? result = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const CreateItinerary(
//                           groups: groups,
//                           creator: SamplePeople.muthu,
//                         )),
//               );
//               if (result != null) {
//                 setState(() => itineraries.add(result));
//                 FirebaseUtils.uploadData("itinerary", {
//                       "date": result.date,
//                       "startTime": result.startTime.format(context),
//                       "endTime": result.endTime.format(context),
//                       "activity": result.activity,
//                       "creator": globalUser.id,
//                       "people": result.people,
//                       "group": globalGroup
//                     });
          
                  
//                 print(result.date);
//                 print(result.startTime);
//                 print(result.endTime);
//                 print(result.activity);
//                 print(result.creator);
//                 print(result.people);
//               } else {
//                 print("NO");
//               }
//             },
//             icon: const Icon(Icons.edit, color: Color(Colours.WHITECONTRAST)),
//             label: const Text("Add Itinerary",
//                 style: TextStyle(color: Color(Colours.WHITECONTRAST))),
//           ),
          
//           ]
//         ));
//   }
// }



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/classes/itinerary.dart';
import 'package:test_app/components/customcard.dart';
import 'package:test_app/components/itineraryblock.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/sampledata/people.dart';
import 'package:test_app/classes/expenditure.dart';
import 'package:test_app/screens/Expenditure/createexpenditure.dart';
import 'package:test_app/components/expenditureblock.dart';
import 'package:test_app/screens/Expenditure/settleup.dart';
import 'package:test_app/screens/Itinerary/createitinerary.dart';
import 'package:test_app/utility/firebaseutils.dart';
import 'package:test_app/utility/globals.dart';

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
    FirebaseUtils.fetchItinerariesByGroupId(globalGroup)
        .then((fetchedItineraries) {
      setState(() {
        itineraries = fetchedItineraries;
      });
    });
    FirebaseUtils.fetchGroupsByUserId(globalUser.id, false).then((fetchedGroups) {
      setState(() {
        groups = fetchedGroups;
        hasLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    groupedData = {};
    for (var entry in itineraries) {
      debugPrint("wwwwwwwww");
      debugPrint(entry.activity);
      DateTime date = DateTime.parse(entry.date);
      String yearMonthDay = DateFormat('yyyy-MM-dd').format(date);
      debugPrint("day: ");
      debugPrint(yearMonthDay);
      if (!groupedData.containsKey(yearMonthDay)) {
        groupedData[yearMonthDay] = [];
      }
      groupedData[yearMonthDay]!.add(entry);
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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            
            FloatingActionButton.extended(
              heroTag: 'add-itinerary-button',
              elevation: 12.0,
              backgroundColor: const Color(Colours.PRIMARY),
              onPressed: !hasLoaded ? null : () async {
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

                    FirebaseUtils.fetchGroupsByUserId(globalUser.id, false).then((fetchedGroups) {
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
              icon: const Icon(Icons.edit, color: Color(Colours.WHITECONTRAST)),
              label: const Text("Add Itinerary",
                  style: TextStyle(color: Color(Colours.WHITECONTRAST))),
            )
          ],
        ));
  }
}
