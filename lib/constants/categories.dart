import 'package:flutter/material.dart';

class CategoryName {
  static const none = "None";
  static const transport = "Transport";
  static const food = "Food";
  static const leisure = "Leisure";
  static const health = "Health";

  static const possibleCategories = [none, transport, food, leisure, health];
}

class CategoryIcon {
  static const none = Icon(Icons.do_not_disturb_on_total_silence_outlined);
  static const transport = Icon(Icons.emoji_transportation);
  static const food = Icon(Icons.fastfood_sharp);
  static const leisure = Icon(Icons.flight);
  static const health = Icon(Icons.local_hospital);

  static const categoryNameToIconMap = {
    CategoryName.none: none,
    CategoryName.transport: transport,
    CategoryName.food: food,
    CategoryName.leisure: leisure,
    CategoryName.health: health,
  };
}
