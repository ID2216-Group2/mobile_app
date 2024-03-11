import 'package:flutter/material.dart';
import 'package:test_app/classes/expenditure.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/components/expendituretile.dart';
import 'package:test_app/utility/globals.dart';

class ExpenditureBlock extends StatelessWidget {
  const ExpenditureBlock(
      {super.key, this.month = "2000-01", this.group = const []});
  final String month;
  final List<Expenditure> group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              alignment: Alignment.centerLeft,
              color: Color(Colours.SECONDARY),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(month,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)),
              ),
            ),
          ),
          ...group.map(
            (expenditure) => ExpenditureTile(
              amount: expenditure.creator == globalUser.id
                  ? expenditure.amount / expenditure.people.length * (expenditure.people.length - 1)
                  : expenditure.amount / expenditure.people.length,
              icon: expenditure.icon,
              category: expenditure.category,
              type: expenditure.creator == globalUser.id
                  ? "lent"
                  : "borrowed",
            ),
          )
        ],
      ),
    );
  }
}
