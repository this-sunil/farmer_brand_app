import 'package:flutter/material.dart';

class FarmerIconWidget extends StatelessWidget {
  final String imgPath;
  final double? width;
  final double? height;
  const FarmerIconWidget({
    super.key,
    required this.imgPath,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Hero(
        tag: imgPath,
        child: Card(
          elevation: 10,
          shape: CircleBorder(side: BorderSide(color: Colors.grey.shade300)),
          child: Container(
            margin: EdgeInsets.all(5),
            width: width ?? 160,
            height: height ?? 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(imgPath),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
