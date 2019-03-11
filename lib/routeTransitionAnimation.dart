import 'package:flutter/material.dart';

class SlideRoute<T> extends PageRouteBuilder<T> {
  final Offset initialSlideOffset;
  final Widget widget;
  SlideRoute({this.initialSlideOffset, this.widget})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return new SlideTransition(
                position: new Tween<Offset>(
                        begin: initialSlideOffset, end: Offset.zero)
                    .animate(CurvedAnimation(
                        parent: animation, curve: Curves.decelerate)),
                child: child,
              );
            });
}
