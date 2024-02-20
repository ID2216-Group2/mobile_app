import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:test_app/classes/memory.dart';
import 'package:test_app/constants/colours.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:test_app/utility/firebaseutils.dart';

final storageRef = FirebaseStorage.instance.ref();

Future<Uint8List?> getDownloadURL(key) => storageRef.child(key).getData();

int _calculateCrossAxisCount(BuildContext context) {
  // You can adjust these values according to your needs
  double width = MediaQuery.of(context).size.width;
  if (width > 400) {
    return 3; // for larger screens
  } else if (width > 300) {
    return 2; // for medium screens
  } else {
    return 1; // for smaller screens
  }
}

class ViewMemoryScreen extends StatefulWidget {
  const ViewMemoryScreen({super.key, required this.memory});
  final Memory memory;
  @override
  ViewMemoryScreenState createState() => ViewMemoryScreenState();
}

class ViewMemoryScreenState extends State<ViewMemoryScreen> {
  Future<Widget> _loadImage(String imagePath) async {
    try {
      String downloadUrl = await storageRef.child(imagePath).getDownloadURL();
      return Image.network(downloadUrl, fit: BoxFit.cover, width: 1000.0);
    } catch (e) {
      return Icon(Icons.error); // Or any placeholder widget for error state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.memory.title}, ${widget.memory.location}'),
        backgroundColor: const Color(Colours.SECONDARY),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
            child: Text(widget.memory.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SaveWidget(memory: widget.memory),
          ),
          ImageCard(image: widget.memory.images[0], width: 500, height: 200),
          const Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 15.0, bottom: 5.0),
            child: Text("Feelings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                textAlign: TextAlign.left),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
            child: Text(widget.memory.comments),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _calculateCrossAxisCount(context),
              crossAxisSpacing: 2,
            ),
            itemCount: widget.memory.images.length,
            itemBuilder: (context, gridIndex) {
              return ImageCard(image: widget.memory.images[gridIndex]);
            },
          ),
          // SizedBox(height: 10),
        ],
      )),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard(
      {super.key, required this.image, this.width = 200, this.height = 150});
  final String image;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDownloadURL(image),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius:
                            BorderRadius.circular(15.0), // Image radius
                        child: Image.memory(
                          snapshot.data as Uint8List,
                          width: width,
                          height: height,
                          fit: BoxFit.cover,
                        )),
                  ]),
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

class SaveWidget extends StatefulWidget {
  final Memory memory;

  SaveWidget({required this.memory});
  @override
  SaveWidgetState createState() => SaveWidgetState();
}

class SaveWidgetState extends State<SaveWidget> {
  // Initial state of the icon
  bool isSolid = false;

  @override
  void initState() {
    super.initState();
    // Initialize isSolid with the value from memory, if it exists; otherwise, false
    isSolid = widget.memory.saved;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isSolid ? Icons.bookmark : Icons.bookmark_outline,
      ),
      onPressed: () {
        // Toggle icon state
        setState(() {
          isSolid = !isSolid;
        });
        // Simulate sending a request
        FirebaseUtils.updateMemorySaved(widget.memory.docid, isSolid);
        print("SENDING ${widget.memory.docid}");
        print(isSolid);
      },
    );
  }
}
