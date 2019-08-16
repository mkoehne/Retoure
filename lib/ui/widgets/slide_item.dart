import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SlideItem extends StatefulWidget {
  final String img;
  final String title;

  SlideItem({
    Key key,
    @required this.img,
    @required this.title,
  }) : super(key: key);

  @override
  _SlideItemState createState() => _SlideItemState();
}

class _SlideItemState extends State<SlideItem> {
  @override
  Widget build(BuildContext context) {
    return Text(
      " ${widget.title} ",
      style: TextStyle(
        fontSize: 25,
      ),
    );
  }
}
