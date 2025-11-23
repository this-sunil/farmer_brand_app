import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoProductScreen extends StatelessWidget {
  const NoProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/icons/empty.json',width: 250,height: 250,fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Text(
              "No products available.",
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          )
        ],

      ),
    );
  }
}
