import 'package:flutter/material.dart';

class ColorUtil {
  static int convertHexColorToInt(String hexColor) {
    StringBuffer buffer = StringBuffer();

    if (hexColor.length == 6 || hexColor.length == 7) {
      buffer.write("ff");
    }

    buffer.write(hexColor);

    return int.parse(buffer.toString().replaceFirst("#", ""), radix: 16);
  }

  static Color revenueColor() {
    return Color(convertHexColorToInt("#02d88f"));
  }

  static Color expenseColor() {
    return Color(convertHexColorToInt("#d83f02"));
  }

  static Color backgroundColor() {
    return Color(convertHexColorToInt("#383838"));
  }
}