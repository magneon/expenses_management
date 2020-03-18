import 'package:flutter/material.dart';

class LayoutDebug extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {        
        return Scaffold(
          body: Center(
            child: Text("Width: ${constraints.maxWidth.toInt()} / ${constraints.maxHeight.toInt()}"),
          ),
        );
      },
    );
  }
}