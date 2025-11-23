import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final VoidCallback onTap;
  const RefreshButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsGeometry.only(bottom:8),
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/icons/village-farmer.png'))
      ),
      height: 300,
      child: Center(
       child:
          ElevatedButton(onPressed: onTap, child: Text('Refresh'))

      ),
    );
  }
}
