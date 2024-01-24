import 'package:flutter/material.dart';

class Memories extends StatefulWidget {
  const Memories({super.key});
  @override
  MemoriesState createState() => MemoriesState();
}

class MemoriesState extends State<Memories> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Memories'),
          SizedBox(height: 10),
        ],
      )),
    );
  }
}
