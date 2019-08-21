import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retoure/ui/utils/theme_changer.dart';

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
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Container(
      color: _themeChanger.getAppTheme().theme.backgroundColor,
      child: Row(
        children: <Widget>[
          Image(
              width: MediaQuery.of(context).size.width / 8,
              fit: BoxFit.fill,
              image: CachedNetworkImageProvider("${widget.img}")),
          Text(
            " ${widget.title} ",
            style: TextStyle(
              color: _themeChanger.getAppTheme().theme.mainTextColor,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}
