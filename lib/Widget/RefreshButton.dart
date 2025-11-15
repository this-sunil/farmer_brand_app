import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final VoidCallback onTap;
  const RefreshButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onTap, child: Text('Refresh'));
  }
}
