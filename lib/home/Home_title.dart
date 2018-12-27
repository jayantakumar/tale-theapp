import 'package:flutter/material.dart';

//title or name appearing at the top left

class HomeTitle extends StatelessWidget {
  const HomeTitle({
    Key key,
    @required String name,
  })  : _name = name,
        super(key: key);

  final String _name;

  @override
  Widget build(BuildContext context) {
    return new Text(
      "Hi $_name".toUpperCase(),
      textScaleFactor: 1.45,
    );
  }
}
