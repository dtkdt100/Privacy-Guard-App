import 'package:flutter/material.dart';

class CircleInfo {
  CircleInfo({
    required this.size,
    this.turns = 0,
    this.alignment = Alignment.topCenter,
    this.borderRadius,
    this.gradient,
  });

  final Size size;
  final double turns;
  final Alignment alignment;
  final BorderRadiusGeometry? borderRadius;
  final Gradient? gradient;
}

class CirclesBackground extends StatelessWidget {
  CirclesBackground({required this.circles, this.child});

  final Widget? child;
  final List<CircleInfo> circles;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: List.generate(
              circles.length, (index) => buildCircle(circles[index])),
        ),
        child ?? SizedBox(),
      ],
    );
  }

  Widget buildCircle(CircleInfo circle) => Align(
        alignment: circle.alignment,
        child: RotationTransition(
          turns: AlwaysStoppedAnimation(circle.turns),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: circle.borderRadius,
              gradient: circle.gradient,
            ),
            width: circle.size.width,
            height: circle.size.height,
          ),
        ),
      );
}
