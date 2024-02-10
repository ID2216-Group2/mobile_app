import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:test_app/constants/colours.dart';
import 'package:firebase_storage/firebase_storage.dart';

final storageRef = FirebaseStorage.instance.ref();

Future<Uint8List?> getDownloadURL(key) => storageRef.child(key).getData();

class ImagePickerCard extends StatelessWidget {
  const ImagePickerCard({super.key, this.imageList = const [], this.getImage});
  final List<String> imageList;
  final VoidCallback? getImage;

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
    final List<Widget> imageSliders = imageList
        .map(
          (item) => Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    FutureBuilder<Widget>(
                      future: _loadImage(item),
                      builder: (BuildContext context,
                          AsyncSnapshot<Widget> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Loading indicator
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error); // Error indicator
                        } else {
                          return snapshot.data!;
                        }
                      },
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                )),
          ),
        )
        .toList();
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            ElevatedButton(
              style: TextButton.styleFrom(
                foregroundColor: Color(Colours.PRIMARY),
                minimumSize: Size(88, 36),
                padding: EdgeInsets.symmetric(horizontal: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              onPressed: getImage,
              child: Text('Add an image'),
            ),
            imageList.isNotEmpty
                ? CarouselSlider(
                    options: CarouselOptions(
                        autoPlay: false,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        pauseAutoPlayOnManualNavigate: true,
                        pauseAutoPlayOnTouch: true,
                        scrollDirection: Axis.horizontal),
                    items: imageSliders,
                  )
                : Text(
                    "There are no images currently. Add an image!",
                    textAlign: TextAlign.center,
                  ),
          ],
        ));
  }
}
