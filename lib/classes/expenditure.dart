import 'package:flutter/material.dart';
import 'package:test_app/constants/categories.dart';
import 'package:test_app/classes/people.dart';

class Expenditure {
  const Expenditure({
    this.date = "2000-01-01",
    this.category = CategoryName.food,
    this.icon = CategoryIcon.food,
    this.amount = 0.0,
    this.creator,
    this.people = const [],
  });
  final String date;
  final String category;
  final double amount;
  final Icon icon;
  final List<Person> people;
  final Person? creator;
}
