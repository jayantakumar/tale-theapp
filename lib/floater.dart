import 'package:flutter/material.dart';

//FLOATING ACTION BUTTON IN OUR APP

class Floater extends StatelessWidget {
  Floater(
      {Key key,
      this.icon = Icons.add,
      this.onPressed,
      this.isAnimated = false,
      this.animatedIcon})
      : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;
  final bool isAnimated;
  final AnimatedIcon animatedIcon;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed == null ? () {} : onPressed,
      child: isAnimated
          ? animatedIcon
          : Icon(
              icon,
              size: 30,
            ),
      backgroundColor: Colors.red,
      shape: CircleBorder(
        side: BorderSide(color: Colors.black, width: 2.0),
      ),
      elevation: 15.0,
      highlightElevation: 0.0,
      //tooltip: "Quick Diary",
    );
  }
}
