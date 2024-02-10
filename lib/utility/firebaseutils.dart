import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/classes/expenditure.dart';
import 'package:test_app/classes/memory.dart';
import 'package:test_app/classes/people.dart';

class FirebaseUtils {
  static Future<void> uploadData(collectionName, data) async {
    CollectionReference col =
        FirebaseFirestore.instance.collection(collectionName);

    return col
        .add(data)
        .then((value) => print(value))
        .catchError((error) => print("Failed to add: $error"));
  }

  static Future<dynamic> retrieveCollection(collectionName) async {
    CollectionReference col =
        FirebaseFirestore.instance.collection(collectionName);

    return col.get().then((QuerySnapshot querySnapshot) {
      return querySnapshot.docs;
    }).catchError((error) => print("Failed to retrieve data: $error"));
  }

  static Future<dynamic> retrieveCollectionFiltered(
      collectionName, filterBy, filterTerm) async {
    CollectionReference col =
        FirebaseFirestore.instance.collection(collectionName);

    return col
        .where(filterBy, arrayContains: filterTerm)
        .get()
        .then((QuerySnapshot querySnapshot) {
      return querySnapshot.docs;
    }).catchError((error) => print("Failed to retrieve data: $error"));
  }

  static Future<List<Expenditure>> fetchExpendituresByGroupId(
      String groupId) async {
    List<Expenditure> expenditures = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('expenditure')
          .where('group',
              isEqualTo: groupId) // Assuming 'group' is the field name
          .get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Assuming you have an Expenditure class that takes a Map<String, dynamic> in its constructor
        Expenditure expenditure = Expenditure.fromMap(data);
        print(expenditure);
        expenditures.add(expenditure);
      }
    } catch (e) {
      print("Error fetching expenditures: $e");
    }
    expenditures.sort((a, b) {
      DateTime dateA = DateTime.parse(a.date);
      DateTime dateB = DateTime.parse(b.date);
      return dateA.compareTo(dateB);
    });
    return expenditures;
  }

  static Future<List<Memory>> fetchMemoriesByGroupId(String groupId) async {
    List<Memory> memories = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('memory')
          .where('group',
              isEqualTo: groupId) // Assuming 'group' is the field name
          .get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Assuming you have an Expenditure class that takes a Map<String, dynamic> in its constructor
        Memory memory = Memory.fromMap(data);
        memories.add(memory);
      }
    } catch (e) {
      print("Error fetching memories: $e");
    }

    memories.sort((a, b) {
      DateTime dateA = DateTime.parse(a.date);
      DateTime dateB = DateTime.parse(b.date);
      return dateA.compareTo(dateB);
    });

    return memories;
  }

  static Future<List<Person>> fetchPeopleByGroupId(String groupId) async {
    List<Person> people = [];

    try {
      // await FirebaseFirestore.instance
      //     .collection('group')
      //     .doc(groupId)
      //     .get()
      //     .then((value) {
      //   print("Hello");
      //   print(value["people"]);
      // });

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('group')
          .doc(groupId)
          .get();
      for (var person in documentSnapshot['people']) {
        DocumentSnapshot personSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(person)
            .get();
        Map<String, dynamic> personData =
            personSnapshot.data() as Map<String, dynamic>;
        personData['id'] = person;
        Person p = Person.fromMap(personData);
        people.add(p);
      }
    } catch (e) {
      print("Error fetching people: $e");
    }

    return people;
  }
}
