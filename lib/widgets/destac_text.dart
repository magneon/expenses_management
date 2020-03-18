import 'package:expenses_management/utils/color_util.dart';
import 'package:flutter/material.dart';

class DestacText extends StatelessWidget {

  final String content;
  final double size;
  final Color color;

  DestacText(this.content, {
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Text(
      content,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: this.color == null ? ColorUtil.backgroundTextColor() : this.color 
      ),
    );
  }
}