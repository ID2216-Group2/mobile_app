import 'package:flutter/material.dart';
import 'package:test_app/components/customcard.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/constants/categories.dart';
import 'package:test_app/sampledata/people.dart';

const currentUser = SamplePeople.muthu;

const sampleData = [
  {
    "date": "240124",
    "category": Categories.food,
    "amount": 50.20,
    "people": [SamplePeople.ali, SamplePeople.bob, SamplePeople.muthu],
    "creator": SamplePeople.muthu
  },
  {
    "date": "100124",
    "category": Categories.food,
    "amount": 23.20,
    "people": [SamplePeople.bob, SamplePeople.muthu],
    "creator": SamplePeople.muthu
  },
  {
    "date": "021223",
    "category": Categories.food,
    "amount": 23.20,
    "people": [SamplePeople.bob, SamplePeople.ali],
    "creator": SamplePeople.ali
  }
];

class Expenditure extends StatefulWidget {
  @override
  ExpenditureState createState() => ExpenditureState();
}

class ExpenditureState extends State<Expenditure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const CustomCard(),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 12.0,
          backgroundColor: const Color(Colours.PRIMARY),
          onPressed: () {},
          icon: const Icon(Icons.edit, color: Color(Colours.WHITECONTRAST)),
          label: const Text("Add Expenditure",
              style: TextStyle(color: Color(Colours.WHITECONTRAST))),
        ));
  }
}
