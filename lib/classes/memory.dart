import 'package:test_app/classes/people.dart';

class Memory {
  Memory(
      {this.date = "2000-01-01",
      this.mainImage = "images/placeholder.png",
      this.images = const [],
      this.location = "Stockholm",
      this.title = "",
      this.comments = "",
      this.creator,
      this.people = const [],
      this.saved = false,
      required this.docid,
      required this.group});
  final String docid;
  final String date;
  final String mainImage;
  final List<dynamic> images;
  final String location;
  final String title;
  final String comments;
  final List<dynamic> people;
  final String? creator;
  final String group;
  bool saved;

  factory Memory.fromMap(Map<String, dynamic> data) {
    return Memory(
        docid: data['docid'],
        date: data['date'],
        mainImage: data['mainImage'],
        images: data['images'],
        location: data['location'],
        title: data['title'],
        comments: data['comments'],
        people: data['people'],
        group: data['group'],
        saved: data.containsKey('saved') ? data['saved'] : false,
        creator: data['creator']);
  }
}
