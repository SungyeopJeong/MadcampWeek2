import 'package:flutter/material.dart';

PageRouteBuilder pageRouteBuilder({
  required Widget page,
  Offset offset = const Offset(1.0, 0.0),
}) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    opaque: false,
    transitionsBuilder: (context, animation, __, child) {
      return SlideTransition(
        position: animation.drive(
          Tween(
            begin: offset,
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.ease)),
        ),
        child: child,
      );
    },
  );
}
