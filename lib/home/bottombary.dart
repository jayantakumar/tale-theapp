import 'package:flutter/material.dart';

//BOTTOM APP BAR DISPLAYED AT HOME

class BottomBary extends StatelessWidget {
  //constructor getting in: AppBar color

  const BottomBary({
    Key key,
    this.color = Colors.indigo,
    this.height = 50,
  }) : super(key: key);

  //color variable

  final Color color;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: AnimatedContainer(
        width: double.infinity,
        color: color,
        height: height,
        duration: Duration(milliseconds: 400),
      ),
      shape: Border(
        top: BorderSide(color: Colors.black, width: 4),
        //bottom: BorderSide(color: Colors.black, width: 4.0)
      ),
    );
  }
}
