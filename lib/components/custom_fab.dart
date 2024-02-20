import 'package:flutter/material.dart';

Widget CustomSizedFloatingActionButton({
  required Icon icon,
  required VoidCallback? onPressed,
  required String heroTag,
  required double elevation,
  double size = 56.0, // Default FAB size is 56.0
  Color backgroundColor = Colors.blue, // Default color
  Color iconColor = Colors.white, // Default icon color
}) {
  return SizedBox(
    width: size,
    height: size,
    child: FloatingActionButton(
      heroTag: heroTag,
      elevation: elevation,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      shape: CircleBorder(),
      child: icon,
    ),
  );
}
