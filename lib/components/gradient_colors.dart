import 'package:flutter/material.dart';

class GradientColors extends StatelessWidget {
  final double opacity;
  final Widget? child;

  const GradientColors({Key? key, this.opacity = 1.0, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Color.fromARGB((255 * opacity).round(), 2, 170, 176),
            Color.fromARGB((255 * opacity).round(), 0, 205, 172),
          ],
        ),
      ),
      child: child,
    );
  }
}
