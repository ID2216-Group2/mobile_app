import 'package:flutter/material.dart';
import '../../../constants/paddings.dart';


class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "HANGOUT",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: defaultPadding * 3),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset(
                "assets/images/theme.png",
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
        const Text(
          "Start to hangout with your friends and", 
          style: TextStyle(fontWeight: FontWeight.w300),
        ),                  
        const Text(
          "share your feelings right now!", 
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: defaultPadding * 0.5),
      ],
    );
  }
}