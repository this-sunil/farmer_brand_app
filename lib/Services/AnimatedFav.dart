import 'package:flutter/material.dart';

class AnimatedFav extends StatelessWidget {
  final Animation<double> scale;
  final Widget child;
  const AnimatedFav({super.key, required this.scale, required this.child});

  @override
  Widget build(BuildContext context) {
    return  ScaleTransition(scale: scale,child: child);
  }
}
