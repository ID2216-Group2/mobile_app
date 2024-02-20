import 'package:flutter/material.dart';
import 'package:test_app/classes/expenditure.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/classes/memory.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/screens/Expenditure/createexpenditure.dart';
import 'package:test_app/screens/Memory/creatememory.dart';
import 'package:test_app/utility/firebaseutils.dart';
import 'package:test_app/utility/globals.dart';

class ItineraryItem extends StatelessWidget {
  const ItineraryItem(
      {super.key,
      required this.startTime,
      required this.endTime,
      required this.activity,
      required this.groupId,
      required this.idx});

  final String startTime;
  final String endTime;
  final String activity;
  final String groupId;
  final int idx;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(Colours.PRIMARY),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    "$startTime - $endTime",
                    style: const TextStyle(
                      color: Color(Colours.WHITECONTRAST),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 120,
                  height: 140,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        activity,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton.extended(
                        heroTag: 'add-expense-button-$idx',
                        backgroundColor: const Color(Colours.PRIMARY),
                        onPressed: () async {
                          Group group =
                              await FirebaseUtils.fetchGroupByGroupId(groupId);

                          if (context.mounted) {
                            final Expenditure? result =
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => CreateExpenditure(
                                              groups: [group],
                                              creator: globalUser.id,
                                            )));
                            if (result != null) {
                              await FirebaseUtils.uploadData("expenditure", {
                                "date": result.date,
                                "category": result.category,
                                "amount": result.amount,
                                "creator": globalUser.id,
                                "people": result.people,
                                "group": globalGroup
                              });
                            }
                          }
                        },
                        label: const Text("Expense",
                            style:
                                TextStyle(color: Color(Colours.WHITECONTRAST))),
                        icon: const Icon(Icons.add,
                            color: Color(Colours.WHITECONTRAST)),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton.extended(
                        heroTag: 'add-memory-button-$idx',
                        backgroundColor: const Color(Colours.PRIMARY),
                        onPressed: () async {
                          Group group =
                              await FirebaseUtils.fetchGroupByGroupId(groupId);

                          if (context.mounted) {
                            final Memory? result = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => CreateMemory(
                                          groups: [group],
                                          creator: globalUser,
                                          activity: activity,
                                        )));

                            if (result != null) {
                              await FirebaseUtils.uploadData("memory", {
                                "date": result.date,
                                "mainImage": result.mainImage,
                                "images": result.images,
                                "location": result.location,
                                "title": result.title,
                                "comments": result.comments,
                                "creator": result.creator,
                                "people": result.people,
                                "group": globalGroup
                              });
                            }
                          }
                        },
                        label: const Text("Memory",
                            style:
                                TextStyle(color: Color(Colours.WHITECONTRAST))),
                        icon: const Icon(Icons.add,
                            color: Color(Colours.WHITECONTRAST)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
