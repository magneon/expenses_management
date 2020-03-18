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

  static Color backgroundColor() {
    return Color(convertHexColorToInt("#DFDFDF"));
  }

  static Color backgroundTextColor() {
    return Color(convertHexColorToInt("#707070"));
  }

  static Color defaultTextColor() {
    return Color(convertHexColorToInt("#DFDFDF"));    
  }

  static Color operationsCardColor() {
    return Color(convertHexColorToInt("#757575"));
  }

  static Color entriesCardColor() {
    return Color(convertHexColorToInt("#434343"));
  }

  static Color revenueColor() {
    return Color(convertHexColorToInt("#11F56C"));
  }

  static Color expenseColor() {
    return Color(convertHexColorToInt("#F51111"));
  }

  static Color filterOptionRevenue() {
    return Color(convertHexColorToInt("#37E67D"));
  }

  static Color filterOptionAll() {
    return Color(convertHexColorToInt("#DFDFDF"));
  }

  static Color filterOptionExpense() {
    return Color(convertHexColorToInt("#FF6464"));
  }

}