import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {super.key,
      this.image = "images/placeholder.png",
      this.title = "placeholder",
      this.fontSize = 25});
  final String image;
  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Text(title,
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.bold))),
          Expanded(
            child: CircleAvatar(
                radius: 48, // Image radius
                backgroundImage: AssetImage(image)),
          )
        ],
      ),
    );
  }
}
