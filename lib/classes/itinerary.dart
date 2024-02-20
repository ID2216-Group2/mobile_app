import 'package:flutter/material.dart';
import 'package:test_app/constants/categories.dart';
import 'package:test_app/classes/people.dart';

class Itinerary {
  const Itinerary({
    required this.group,
    required this.creator,
    this.date = "",
    this.activity = "",
    this.startTime = "",
    this.endTime = "",
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
