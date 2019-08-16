import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retoure/model/retoure.dart';
import 'package:retoure/model/state.dart';
import 'package:retoure/ui/utils/state_widget.dart';
import 'package:retoure/ui/utils/store.dart';
import 'package:retoure/ui/utils/theme_changer.dart';
import 'package:retoure/ui/widgets/retoure_image.dart';
import 'package:retoure/ui/widgets/retoure_title.dart';

import '../../state_widget.dart';

class DetailScreen extends StatefulWidget {
  final Retoure recipe;
  final bool inFavorites;

  DetailScreen(this.recipe, this.inFavorites);

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
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
    _inFavorites = widget.inFavorites;
  }

  @override
  void dispose() {
    // "Unmount" the controllers:
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleInFavorites() {
    setState(() {
      _inFavorites = !_inFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
        appBar: AppBar(
      centerTitle: true,
      iconTheme:
          IconThemeData(color: _themeChanger.getAppTheme().theme.mainTextColor),
      brightness: _themeChanger.getAppTheme().theme.brightness,
      backgroundColor: _themeChanger.getAppTheme().theme.mainBackgroundColor,
      title: Text(
        widget.recipe.name,
        style: TextStyle(
            fontSize: 24.0,
            color: _themeChanger.getAppTheme().theme.mainTextColor),
      ),
    ));
  }
}
