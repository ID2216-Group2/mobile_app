import 'package:flutter/material.dart';

class ItineraryTile extends StatelessWidget {
  const ItineraryTile(
      {super.key,
      this.activity = "abc",
      this.startTime = "4:30",
      this.endTime = "4:30",
      this.fontSize = 25});
  final String activity;
  final String startTime;
  final String endTime;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(activity,
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
                child: Text(" ${startTime} - ${endTime}",
                    style:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 15)),
              ),
              ],
            ))
        ],
      ),
    );
  }
}
