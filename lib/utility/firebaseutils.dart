import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/classes/expenditure.dart';
import 'package:test_app/classes/memory.dart';
import 'package:test_app/classes/people.dart';
import 'package:test_app/classes/group.dart';

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

  static Future<Person> fetchUserByUserId(String userId) async {
    DocumentSnapshot personSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    Map<String, dynamic> personData =
        personSnapshot.data() as Map<String, dynamic>;
    personData['id'] = userId;
    return Person.fromMap(personData);
  }

  static Future<List<Group>> fetchGroupsByUserId(String userId, bool ignore_currentUser) async {
    List<Group> groups = [];

    QuerySnapshot groupSnapshot = await FirebaseFirestore.instance
        .collection('group')
        .where('people', arrayContains: userId)
        .get();
          
    for (QueryDocumentSnapshot groupDoc in groupSnapshot.docs) {
      Map<String, dynamic> groupData = groupDoc.data() as Map<String, dynamic>;
      List<dynamic> peopleIds = groupData['people'];
      List<Person> people = [];
      for (String personId in peopleIds) {
        if (ignore_currentUser && personId == userId) { continue; }
        Person p = await fetchUserByUserId(personId);
        people.add(p);
      }
      groupData['id'] = groupDoc.id;
      groupData['name'] = groupData['groupname'];
      groupData['people'] = people;
      groups.add(Group.fromMap(groupData));
    }

    return groups;
  }

  static Future<List<Person>> fetchOtherUsersByUserId(String userId) async {
    List<Person> otherUsers = [];

    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where(FieldPath.documentId, isNotEqualTo: userId)
      .get();
    
    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      Person user = Person(
        id: userDoc.id,
        name: userData['name'],
        // email: userData['email'],
        // password: userData['password']
      );
      otherUsers.add(user);
    }

    return otherUsers;
  }

  static Future<List<List<double>>> fetchBillsByGroupId(String groupId) async {
    DocumentSnapshot groupDoc = await FirebaseFirestore.instance
      .collection('group')
      .doc(groupId)
      .get();
    Map<String, dynamic> groupData = groupDoc.data() as Map<String, dynamic>;
    List<List<double>> bills = Group.decodeBills(groupData['bill']);
    return bills;
  }

  static Future<void> updateGroupExpenditure(String groupId, String payeeId, double amount) async {
    DocumentSnapshot groupDoc = await FirebaseFirestore.instance
      .collection('group')
      .doc(groupId)
      .get();
    Map<String, dynamic> groupData = groupDoc.data() as Map<String, dynamic>;
    List<dynamic> peopleIds = groupData['people'];
    List<List<double>> bills = Group.decodeBills(groupData['bill']);
    double amountOwed = amount / peopleIds.length;
    int payeeIdx = peopleIds.indexOf(payeeId);
    
    for (var i = 0; i < peopleIds.length; i++) {
      if (i == payeeIdx) { continue; }
      bills[payeeIdx][i] += amountOwed;
    }

    String billsStr = Group.encodeBills(bills);
    groupDoc.reference.update({ "bill": billsStr });
  }

  static Future<void> updateGroupBills(String groupId, List<List<double>> billMatrix) async {
    DocumentSnapshot groupDoc = await FirebaseFirestore.instance
      .collection('group')
      .doc(groupId)
      .get();
    String billsStr = Group.encodeBills(billMatrix);
    groupDoc.reference.update({ "bill": billsStr });
  }
}
