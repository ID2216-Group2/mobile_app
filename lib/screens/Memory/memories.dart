import 'package:flutter/material.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/classes/memory.dart';
import 'package:test_app/components/memorytile.dart';
import 'package:test_app/screens/Memory/creatememory.dart';
import 'package:test_app/sampledata/people.dart';
import 'package:test_app/utility/firebaseutils.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/utility/globals.dart';
import 'package:test_app/classes/people.dart';
import 'package:test_app/components/custom_fab.dart';

const currentUser = SamplePeople.muthu;

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});
  @override
  MemoriesScreenState createState() => MemoriesScreenState();
}

class MemoriesScreenState extends State<MemoriesScreen> {
  List<Memory> data = [];
  List<Group> groups = [];
  bool hasLoaded = false;
  Person? creator;

  @override
  void initState() {
    hasLoaded = false;
    super.initState();
    if (globalGroup != "NULL") {
      FirebaseUtils.fetchMemoriesByGroupId(globalGroup).then((fetchedMemories) {
        setState(() {
          data = fetchedMemories;
        });
      });
    }
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
      setState(() {
        data = fetchedMemories;
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
    if (globalGroup == "NULL") {
      return const Scaffold(
        body: Center(
          child: Text("Please create and select a group\n"),
        ),
      );
    }
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
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
        floatingActionButton: CustomSizedFloatingActionButton(
          heroTag: "add-memory",
          elevation: 12.0,
          backgroundColor: const Color(Colours.PRIMARY),
          onPressed: () async {
            final Memory? result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateMemory(
                        groups: groups,
                        creator: globalUser,
                      )),
            );
            if (result != null) {
              setState(() => data.add(result));
              FirebaseUtils.uploadData("memory", {
                "date": result.date,
                "mainImage": result.mainImage,
                "images": result.images,
                "location": result.location,
                "title": result.title,
                "comments": result.comments,
                "creator": result.creator,
                "people": result.people,
                "group": globalGroup,
                "saved": result.saved
              }).then((_) {
                FirebaseUtils.fetchMemoriesByGroupId(globalGroup)
                    .then((fetchedMemories) {
                  setState(() {
                    data = fetchedMemories;
                  });
                });
              });
            } else {
              print("NO");
            }
          },
          icon: const Icon(Icons.add, color: Color(Colours.WHITECONTRAST)),
        ));
  }
}
