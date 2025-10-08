import 'package:flutter/material.dart';

class FavAnimatedIcon extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final VoidCallback callback;
  const FavAnimatedIcon({
    super.key,
    required this.animation,
    required this.child,
    required this.callback
  });
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: IconButton(
          onPressed: callback,
          icon: child,
          color: Colors.red
      ),
    );
  }
}
