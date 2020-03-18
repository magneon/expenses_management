import 'package:flutter/material.dart';

class AppCard extends StatefulWidget {

  final Color color;
  final double width;
  final double height;
  final Widget child;

  AppCard({this.color, this.width, this.height, this.child});

  @override
  _AppCardState createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      color: widget.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        )
      ),
      child: Container(
        width: widget.width,
        height: widget.height,
        child: widget.child,
      ),
    );
  }
}