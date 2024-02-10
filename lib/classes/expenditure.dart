import 'package:flutter/material.dart';
import 'package:test_app/constants/categories.dart';

class Expenditure {
  const Expenditure({
    this.date = "2000-01-01",
    required this.group,
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
  final String group;
  final List<dynamic> people;
  final String? creator;

  factory Expenditure.fromMap(Map<String, dynamic> data) {
    return Expenditure(
        date: data['date'],
        category: data['category'],
        icon: CategoryIcon.categoryNameToIconMap[data['category']] as Icon,
        amount: data['amount'],
        people: data['people'],
        group: data['group'],
        creator: data['creator']);
  }
}
