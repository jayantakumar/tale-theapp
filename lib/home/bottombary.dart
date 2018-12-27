import 'package:flutter/material.dart';

//BOTTOM APP BAR DISPLAYED AT HOME

class BottomBary extends StatelessWidget {
  const BottomBary({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.yellow,
      type: MaterialType.canvas,
      child: Container(
        width: double.infinity,
        height: 50,
      ),
      shape: Border(
        top: BorderSide(color: Colors.black, width: 4),
        //bottom: BorderSide(color: Colors.black, width: 4.0)
      ),
    );
  }
}
