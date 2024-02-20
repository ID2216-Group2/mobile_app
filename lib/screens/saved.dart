import 'package:flutter/material.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/classes/memory.dart';
import 'package:test_app/components/memorytile.dart';
import 'package:test_app/sampledata/people.dart';
import 'package:test_app/utility/firebaseutils.dart';
import 'package:test_app/utility/globals.dart';
import 'package:test_app/classes/people.dart';

const currentUser = SamplePeople.muthu;

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});
  @override
  SavedScreenState createState() => SavedScreenState();
}

class SavedScreenState extends State<SavedScreen> {
  List<Memory> data = [];
  List<Group> groups = [];
  bool hasLoaded = false;
  Person? creator;

  @override
  void initState() {
    hasLoaded = false;
    super.initState();

    FirebaseUtils.fetchMemoriesByGroupId(globalGroup).then((fetchedMemories) {
      var filteredMemories = fetchedMemories.where((memory) {
        // Replace this condition with whatever you need
        // For example, to keep memories from 2021:
        return memory.saved == true;
      }).toList(); // Convert the iterable back to a List
      setState(() {
        data = filteredMemories;
      });
    });

    FirebaseUtils.fetchGroupsByUserId(globalUser.id, false)
        .then((fetchedGroups) {
      setState(() {
        print(fetchedGroups);
        print(globalUser.id);
        groups = fetchedGroups;
        hasLoaded = true;
      });
    });
  }

  void updateMemories() {
    FirebaseUtils.fetchMemoriesByGroupId(globalGroup).then((fetchedMemories) {
      var filteredMemories = fetchedMemories.where((memory) {
        // Replace this condition with whatever you need
        // For example, to keep memories from 2021:
        return memory.saved == true;
      }).toList(); // Convert the iterable back to a List
      setState(() {
        data = filteredMemories;
      });
    });
  }

  int _calculateCrossAxisCount(BuildContext context) {
    // You can adjust these values according to your needs
    double width = MediaQuery.of(context).size.width;
    if (width > 400) {
      return 3; // for larger screens
    } else if (width > 300) {
      return 2; // for medium screens
    } else {
      return 1; // for smaller screens
    }
  }

  Map<String, List<Memory>> get _groupedData {
    Map<String, List<Memory>> groupedData = {};
    for (var memory in data) {
      String groupKey =
          '${memory.date.split("-")[0]}-${memory.date.split("-")[1]}';
      if (!groupedData.containsKey(groupKey)) {
        groupedData[groupKey] = [];
      }
      groupedData[groupKey]!.add(memory);
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _groupedData.length,
        itemBuilder: (context, index) {
          String group = _groupedData.keys.elementAt(index);
          List<Memory> memories = _groupedData[group]!;

          return Padding(
            padding: index == _groupedData.length - 1
                ? EdgeInsets.only(bottom: 50.0)
                : EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    group,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _calculateCrossAxisCount(context),
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: memories.length,
                  itemBuilder: (context, gridIndex) {
                    return MemoryTile(
                        memory: memories[gridIndex],
                        updateMemories: updateMemories);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
