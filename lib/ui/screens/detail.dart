import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retoure/model/retoure.dart';
import 'package:retoure/model/state.dart';
import 'package:retoure/ui/utils/state_widget.dart';
import 'package:retoure/ui/utils/theme_changer.dart';

class DetailScreen extends StatefulWidget {
  final Retoure retoure;

  DetailScreen(this.retoure);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  bool _inFavorites;
  StateModel appState;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: _themeChanger.getAppTheme().theme.mainTextColor),
        brightness: _themeChanger.getAppTheme().theme.brightness,
        backgroundColor: _themeChanger.getAppTheme().theme.mainBackgroundColor,
        title: Text(
          widget.retoure.name,
          style: TextStyle(
              fontSize: 24.0,
              color: _themeChanger.getAppTheme().theme.mainTextColor),
        ),
      ),
      body: Column(
        children: <Widget>[
          Image(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              fit: BoxFit.fill,
              image: CachedNetworkImageProvider("${widget.retoure.imageURL}")),
          Text(
            widget.retoure.notes,
            style: TextStyle(
                fontSize: 24.0,
                color: _themeChanger.getAppTheme().theme.mainTextColor),
          ),
        ],
      ),
    );
  }
}
