import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:test_app/classes/memory.dart';
import 'package:test_app/screens/Memory/viewmemory.dart';

final storageRef = FirebaseStorage.instance.ref();

Future<Uint8List?> getDownloadURL(key) => storageRef.child(key).getData();

class MemoryTile extends StatelessWidget {
  const MemoryTile(
      {super.key,
      required this.memory,
      this.fontSize = 12,
      required this.updateMemories});
  final Memory memory;
  final double fontSize;
  final VoidCallback updateMemories;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDownloadURL(memory.mainImage),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewMemoryScreen(memory: memory)));
                updateMemories();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius:
                              BorderRadius.circular(15.0), // Image radius
                          child: Image.memory(
                            snapshot.data as Uint8List,
                            width: 200,
                            height: 100,
                            fit: BoxFit.cover,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 60,
                          width: 100,
                          child: Column(
                            children: [
                              Expanded(
                                  child: Text(memory.title,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w400))),
                              Expanded(
                                  child: Text(memory.date,
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w300))),
                              Expanded(
                                  child: Text(memory.location,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w200))),
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(15.0),
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
