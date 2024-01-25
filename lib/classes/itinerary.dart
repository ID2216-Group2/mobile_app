import 'package:flutter/material.dart';
import 'package:test_app/constants/categories.dart';
import 'package:test_app/classes/people.dart';

class Itinerary {
  const Itinerary({
    this.date = "2000-01-01",
    this.activity = "museum",
    this.startTime = const TimeOfDay(hour: 4, minute: 20),
    this.endTime = const TimeOfDay(hour: 6, minute: 20),
    this.creator,
    this.people = const [],
  });
  final String date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<Person> people;
  final String activity;
  final Person? creator;
}
