import 'package:flutter/material.dart';

//BOTTOM APP BAR DISPLAYED AT HOME

class BottomBary extends StatelessWidget {
  const BottomBary({
    Key key,
    this.color = Colors.yellow,
  }) : super(key: key);

  final Color color;
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: AnimatedContainer(
        width: double.infinity,
        color: color,
        height: 50,
        duration: Duration(milliseconds: 400),
      ),
      shape: Border(
        top: BorderSide(color: Colors.black, width: 4),
        //bottom: BorderSide(color: Colors.black, width: 4.0)
      ),
    );
  }
}
