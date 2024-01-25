import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/components/customcard.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/constants/categories.dart';
import 'package:test_app/sampledata/people.dart';
import 'package:test_app/classes/expenditure.dart';
import 'package:test_app/screens/createexpenditure.dart';
import 'package:test_app/components/expenditureblock.dart';

const currentUser = SamplePeople.muthu;

const sampleGroup = [SamplePeople.muthu, SamplePeople.ali, SamplePeople.bob];

class ExpenditureScreen extends StatefulWidget {
  const ExpenditureScreen({super.key});
  @override
  ExpenditureScreenState createState() => ExpenditureScreenState();
}

class ExpenditureScreenState extends State<ExpenditureScreen> {
  List<Expenditure> sampleData = [
    Expenditure(
        date: "2024-01-24",
        category: CategoryName.food,
        icon: CategoryIcon.food,
        amount: 50.20,
        people: [SamplePeople.ali, SamplePeople.bob, SamplePeople.muthu],
        creator: SamplePeople.muthu),
    Expenditure(
        date: "2024-01-10",
        category: CategoryName.leisure,
        icon: CategoryIcon.leisure,
        amount: 23.20,
        people: [SamplePeople.bob, SamplePeople.muthu],
        creator: SamplePeople.muthu),
    Expenditure(
        date: "2023-12-12",
        category: CategoryName.food,
        icon: CategoryIcon.food,
        amount: 23.20,
        people: [SamplePeople.bob, SamplePeople.ali],
        creator: SamplePeople.ali)
  ];
  Map<String, List<Expenditure>> groupedData = {};

  @override
  Widget build(BuildContext context) {
    groupedData = {};
    for (var entry in sampleData) {
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
        floatingActionButton: FloatingActionButton.extended(
          elevation: 12.0,
          backgroundColor: const Color(Colours.PRIMARY),
          onPressed: () async {
            final Expenditure? result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateExpenditure(
                        group: sampleGroup,
                        creator: SamplePeople.muthu,
                      )),
            );
            if (result != null) {
              setState(() => sampleData.add(result));
              print(result.date);
              print(result.category);
              print(result.amount);
              print(result.creator);
              print(result.people);
            } else {
              print("NO");
            }
          },
          icon: const Icon(Icons.edit, color: Color(Colours.WHITECONTRAST)),
          label: const Text("Add Expenditure",
              style: TextStyle(color: Color(Colours.WHITECONTRAST))),
        ));
  }
}
