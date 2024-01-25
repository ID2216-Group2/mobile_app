import 'package:flutter/material.dart';

class ExpenditureTile extends StatelessWidget {
  const ExpenditureTile(
      {super.key,
      this.icon = const Icon(Icons.person),
      this.category = "Placeholder",
      this.amount = 0,
      this.name = "Placeholder",
      this.type = "borrowed",
      this.fontSize = 25});
  final Icon icon;
  final String category;
  final String name;
  final String type;
  final double amount;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 50, right: 50, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              icon,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(category,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic)),
              )
            ],
          )),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text("You $type",
                    style:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 10)),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text("\$${amount.toStringAsFixed(2)}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
