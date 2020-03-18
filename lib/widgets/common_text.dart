import 'package:expenses_management/utils/color_util.dart';
import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {

  final String content;
  final double size;
  final Color color;

  CommonText(this.content, {
    this.size,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        fontSize: size,
        color: this.color == null ? ColorUtil.backgroundTextColor() : this.color
      ),
    );
  }
}