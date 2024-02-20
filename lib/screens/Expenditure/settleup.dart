import 'package:flutter/material.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/classes/people.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/screens/Expenditure/components/bill.dart';
import 'package:test_app/utility/firebaseutils.dart';
import 'package:test_app/utility/globals.dart';

class Bill {
  final String otherUsername;
  final int otherUserIdx;
  final int userIdx;
  final double amount;

  Bill(this.otherUsername, this.otherUserIdx, this.userIdx, this.amount);
}

class SettleUpState extends State<SettleUpScreen> {
  final TextEditingController groupController = TextEditingController();

  Group? selectedGroup;
  List<Bill> bills = [];
  List<List<double>> billMatrix = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settle Up'),
          backgroundColor: const Color(Colours.SECONDARY),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                      child: DropdownMenu(
                    expandedInsets: EdgeInsets.zero,
                    controller: groupController,
                    requestFocusOnTap: false,
                    label: const Text('Group'),
                    onSelected: (group) {
                      setState(() {
                        bills.clear();

                        selectedGroup = group as Group;
                        billMatrix = selectedGroup!.bills;
                        List<Person> people = selectedGroup!.people;
                        int currentUserIdx = people
                            .indexWhere((person) => person.id == globalUser.id);

                        for (var i = 0; i < people.length; i++) {
                          if (people[i].id == globalUser.id) {
                            continue;
                          }
                          double amountLent = billMatrix[i][currentUserIdx] -
                              billMatrix[currentUserIdx][i];
                          if (amountLent != 0) {
                            bills.add(Bill(
                                people[i].name, i, currentUserIdx, amountLent));
                          }
                        }
                      });
                    },
                    dropdownMenuEntries: widget.groups
                        .map((item) =>
                            DropdownMenuEntry(label: item.name, value: item))
                        .toList(),
                  ))),
              Expanded(
                child: ListView.builder(
                  itemCount: bills.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BillItem(
                      otherUsername: bills[index].otherUsername,
                      amountLent: bills[index].amount,
                      onPressed: () {
                        setState(() {
                          billMatrix[bills[index].userIdx]
                              [bills[index].otherUserIdx] = 0;
                          billMatrix[bills[index].otherUserIdx]
                              [bills[index].userIdx] = 0;
                          FirebaseUtils.updateGroupBills(
                              selectedGroup!.id, billMatrix);
                          bills.removeAt(index);
                        });
                      },
                    );
                  },
                ),
              ),
            ]),
          ),
        ));
  }
}

class SettleUpScreen extends StatefulWidget {
  const SettleUpScreen({super.key, required this.groups});

  final List<Group> groups;

  @override
  SettleUpState createState() => SettleUpState();
}
