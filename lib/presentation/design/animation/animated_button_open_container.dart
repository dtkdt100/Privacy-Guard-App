import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

typedef ChildAnimatedButton = Widget Function(VoidCallback);

class AnimatedButtonOpenContainer extends OpenContainer {
  AnimatedButtonOpenContainer({
    required Widget openPage,
    required ChildAnimatedButton child,
    Duration duration = const Duration(milliseconds: 300),
    ShapeBorder border = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        side: BorderSide(color: Colors.transparent)),
    ClosedCallback<Object?>? onClosed,
  }) : super(
          openBuilder: (context, openContainer) => openPage,
          closedBuilder: (context, openContainer) {
            return child(openContainer);
          },
          transitionDuration: duration,
          closedShape: border,
          onClosed: onClosed,
        );
}
