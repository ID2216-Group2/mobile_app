import 'package:test_app/classes/people.dart';

class Memory {
  const Memory({
    this.date = "2000-01-01",
    this.mainImage = "images/placeholder.png",
    this.images = const [],
    this.location = "Stockholm",
    this.title = "",
    this.comments = "",
    this.creator,
    this.people = const [],
  });
  final String date;
  final String mainImage;
  final List<String> images;
  final String location;
  final String title;
  final String comments;
  final List<Person> people;
  final Person? creator;
}
