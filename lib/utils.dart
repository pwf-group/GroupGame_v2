import 'dart:math';
import 'package:flutter/material.dart';

class MyColor {
  static List<Color> colors = [
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.orange[900],
    Colors.lime[800],
    Colors.teal,
    Colors.indigo,
    Colors.grey[800],
  ];

  static Color random() {
    int index = Random.secure().nextInt(colors.length);
    return colors[index];
  }

  static String randomHex() {
    return random().value.toRadixString(16);
  }

  static Color hexToColor(String hex) {
    if (hex.isEmpty)
      return null;

    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return Color(val);
  }
}

double minScreenSize(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return min(width, height);
}
