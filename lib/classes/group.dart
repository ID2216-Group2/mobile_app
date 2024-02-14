import 'dart:convert';
import 'package:test_app/classes/people.dart';

class Group {
  final String id;
  final String name;
  final List<Person> people;
  final List<List<double>> bills;
  const Group(
      {this.id = "",
      this.name = "",
      this.people = const [],
      this.bills = const []});

  factory Group.fromMap(Map<String, dynamic> data) {
    return Group(
      id: data['id'],
      name: data['name'],
      people: data['people'],
      bills: decodeBills(data['bill'])
    );
  }

  Map<String, dynamic> toDbObject() {
    return {
      "groupname": name,
      "people": people.map((person) {
        return person.id;
      }).toList(),
      "bill": encodeBills(bills)
    };
  }

  static List<List<double>> decodeBills(String billsStr) {
    var billMatrix = jsonDecode(billsStr);
    List<List<double>> bills = List<List<double>>.from(billMatrix.map((row){
      return List<double>.from(row.map((value) => double.parse(value.toString())));
    }));
    return bills;
  }
  
  static String encodeBills(List<List<double>> bills) {
    return jsonEncode(bills);
  }
}
