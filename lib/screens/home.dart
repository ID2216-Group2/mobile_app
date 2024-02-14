import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/utility/firebaseutils.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUtils.retrieveCollection("expenditure").then((x) => {
          x.forEach((s) => {print(s.id)})
        });
    return Scaffold(
      appBar: AppBar(
        title: Text("Items"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(
                    data['name']), // Assuming each document has a 'name' field
                subtitle: Text(data['email']), // Assuming a 'description' field
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
