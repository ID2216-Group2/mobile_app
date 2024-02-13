import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/components/customcard.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/sampledata/people.dart';
import 'package:test_app/classes/expenditure.dart';
import 'package:test_app/screens/Expenditure/createexpenditure.dart';
import 'package:test_app/components/expenditureblock.dart';
import 'package:test_app/screens/Expenditure/settleup.dart';
import 'package:test_app/utility/firebaseutils.dart';
import 'package:test_app/utility/globals.dart';

const currentUser = SamplePeople.muthu;

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

  @override
  void initState() {
    super.initState();
    FirebaseUtils.fetchExpendituresByGroupId(globalGroup)
        .then((fetchedExpenditures) {
      setState(() {
        expenditures = fetchedExpenditures;
      });
    });
    FirebaseUtils.fetchGroupsByUserId(globalUser, false).then((fetchedGroups) {
      setState(() {
        groups = fetchedGroups;
        hasLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.only(bottom: 100),
          child: Column(children: <Widget>[
            const CustomCard(),
            Column(
              children: groupedData.entries
                  .map((e) => ExpenditureBlock(month: e.key, group: e.value))
                  .toList(),
            )
          ]),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'settle-up-button',
              elevation: 12.0,
              backgroundColor: const Color(Colours.PRIMARY),
              onPressed: !hasLoaded ? null : () {
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
              label: const Text("Settle Up",
                  style: TextStyle(color: Color(Colours.WHITECONTRAST))),
            ),
            SizedBox(width: 80),
            FloatingActionButton.extended(
              heroTag: 'add-expenditure-button',
              elevation: 12.0,
              backgroundColor: const Color(Colours.PRIMARY),
              onPressed: !hasLoaded ? null : () async {
                final Expenditure? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateExpenditure(
                            groups: groups,
                            creator: globalUser,
                          )),
                );
                if (result != null) {
                  setState(() => expenditures.add(result));
                  FirebaseUtils.uploadData("expenditure", {
                    "date": result.date,
                    "category": result.category,
                    "amount": result.amount,
                    "creator": globalUser,
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

                    FirebaseUtils.fetchGroupsByUserId(globalUser, false).then((fetchedGroups) {
                      setState(() {
                        groups = fetchedGroups;
                        hasLoaded = true;
                      });
                    });
                  });

                  String groupId = result.group;
                  await FirebaseUtils.updateGroupExpenditure(
                      groupId, globalUser, result.amount);
                } else {
                  print("NO");
                }
              },
              icon: const Icon(Icons.edit, color: Color(Colours.WHITECONTRAST)),
              label: const Text("Add Expenditure",
                  style: TextStyle(color: Color(Colours.WHITECONTRAST))),
            )
          ],
        ));
  }
}
