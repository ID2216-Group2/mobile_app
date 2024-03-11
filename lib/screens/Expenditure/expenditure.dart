import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/components/customcard.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/classes/expenditure.dart';
import 'package:test_app/screens/Expenditure/createexpenditure.dart';
import 'package:test_app/components/expenditureblock.dart';
import 'package:test_app/screens/Expenditure/settleup.dart';
import 'package:test_app/utility/firebaseutils.dart';
import 'package:test_app/utility/globals.dart';
import 'package:test_app/components/custom_fab.dart';

class ExpenditureScreen extends StatefulWidget {
  const ExpenditureScreen({super.key});
  @override
  ExpenditureScreenState createState() => ExpenditureScreenState();
}

class ExpenditureScreenState extends State<ExpenditureScreen> {
  List<Group> groups = [];
  List<Expenditure> expenditures = [];
  Map<String, List<Expenditure>> groupedData = {};
  bool hasLoaded = false;
  String? lastGlobalGroup;
  Group? currentGroup;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if globalGroup has changed
    if (globalGroup != lastGlobalGroup) {
      _fetchData();  // Call _fetchData to update the UI with new group data
    }
  }

  void _fetchData() {
    if (globalGroup != "NULL") {
      hasLoaded = false;
      FirebaseUtils.fetchExpendituresByGroupId(globalGroup)
          .then((fetchedExpenditures) {
        setState(() {
          expenditures = fetchedExpenditures;
          lastGlobalGroup = globalGroup;
        });
      });

      FirebaseUtils.fetchGroupByGroupId(globalGroup)
        .then((fetchedGroup) {
          setState(() {
            currentGroup = fetchedGroup;
          });
        });

      FirebaseUtils.fetchGroupsByUserId(globalUser.id, false)
          .then((fetchedGroups) {
        setState(() {
          groups = fetchedGroups;
          hasLoaded = true;
        });
      });
    }
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
    for (var entry in expenditures) {
      DateTime date = DateTime.parse(entry.date);
      String yearMonth = DateFormat('yyyy-MM').format(date);

      if (!groupedData.containsKey(yearMonth)) {
        groupedData[yearMonth] = [];
      }
      groupedData[yearMonth]!.add(entry);
    }
    return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 130),
          child: Column(children: <Widget>[
            currentGroup != null ? CustomCard(title: (currentGroup as Group).name) : const CustomCard(),
            Column(
              children: groupedData.entries
                  .map((e) => ExpenditureBlock(month: e.key, group: e.value))
                  .toList(),
            )
          ]),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomSizedFloatingActionButton(
              heroTag: 'settle-up-button',
              elevation: 12.0,
              backgroundColor: const Color(Colours.PRIMARY),
              onPressed: !hasLoaded
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettleUpScreen(
                                  groups: groups,
                                )),
                      );
                    },
              icon:
                  const Icon(Icons.check, color: Color(Colours.WHITECONTRAST)),
            ),
            SizedBox(
              height: 10,
            ),
            CustomSizedFloatingActionButton(
              heroTag: 'add-expenditure-button',
              elevation: 12.0,
              backgroundColor: const Color(Colours.PRIMARY),
              onPressed: !hasLoaded
                  ? null
                  : () async {
                      final Expenditure? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateExpenditure(
                                  groups: groups,
                                  creator: globalUser.id,
                                )),
                      );
                      if (result != null) {
                        setState(() => expenditures.add(result));
                        FirebaseUtils.uploadData("expenditure", {
                          "date": result.date,
                          "category": result.category,
                          "amount": result.amount,
                          "creator": globalUser.id,
                          "people": result.people,
                          "group": globalGroup
                        }).then((_) {
                          // Fetch the latest data again after adding a new expenditure
                          FirebaseUtils.fetchExpendituresByGroupId(globalGroup)
                              .then((fetchedExpenditures) {
                            setState(() {
                              expenditures = fetchedExpenditures;
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
                        await FirebaseUtils.updateGroupExpenditure(
                            groupId, globalUser.id, result.amount);
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
