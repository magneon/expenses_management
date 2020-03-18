import 'package:expenses_management/utils/color_util.dart';
import 'package:expenses_management/widgets/common_text.dart';
import 'package:flutter/material.dart';

class DefaultContent extends StatefulWidget {
  @override
  _DefaultContentState createState() => _DefaultContentState();
}

class _DefaultContentState extends State<DefaultContent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 5),
      scrollDirection: Axis.vertical,
      itemCount: 10,
      itemBuilder: (context, index) {
        return CommonText("Item Comum $index", size: 20, color: ColorUtil.backgroundColor());
      }
    );
  }
}