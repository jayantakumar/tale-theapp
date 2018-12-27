import 'package:flutter/material.dart';

//FLOATING ACTION BUTTON IN OUR APP

class Floater extends StatelessWidget {
  const Floater({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: Icon(
        Icons.add,
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
