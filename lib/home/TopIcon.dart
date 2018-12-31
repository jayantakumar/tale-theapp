//icon appearing at the top left of the home page

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopIcon extends StatelessWidget {
  final String _path;

  TopIcon(this._path);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset(
        _path,
        fit: BoxFit.contain,
      ),
    );
  }
}
