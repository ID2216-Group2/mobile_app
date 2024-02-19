import 'package:flutter/material.dart';
import 'package:test_app/constants/categories.dart';
import 'package:test_app/classes/people.dart';

class Itinerary {
  const Itinerary({
    this.date = "2000-01-01",
    required this.group,
    this.activity = "museum",
    this.startTime = "4:20",
    this.endTime = "6:20",
    this.creator,
    this.people = const [],
  });
  final String date;
  final String startTime;
  final String endTime;
  final List<dynamic> people;
  final String group;
  final String activity;
  final String? creator;

  factory Itinerary.fromMap(Map<String, dynamic> data) {
    return Itinerary(
        date: data['date'],
        activity: data['activity'],
        startTime: data['startTime'],
        endTime: data['endTime'],
        creator: data['creator'],
        group: data['group'],
        people: data['people'],
    );  
  }
}
