import 'package:flutter/material.dart';

class RetoureImage extends StatelessWidget {
  final String imageURL;

  RetoureImage(this.imageURL);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Image.network(
        imageURL,
        fit: BoxFit.cover,
      ),
    );
  }
}
