import 'package:test_app/classes/people.dart';

class Group {
  final String id;
  final String name;
  final List<Person> people;
  const Group({required this.id, this.name = "", this.people = const []});
  factory Group.fromMap(Map<String, dynamic> data) {
    return Group(
      id: data['id'],
      name: data['name'],
      people: data['people'],
    );
  }
}