import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
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
  Retoure retoure;

  @override
  void initState() {
    super.initState();
    retoure = widget.retoure;
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
      body: Container(
        color: _themeChanger.getAppTheme().theme.backgroundColor,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HeroPhotoViewWrapper(
                        imageProvider: CachedNetworkImageProvider(
                            "${widget.retoure.imageURL}"),
                      ),
                    ));
              },
              child: Container(
                  child: Hero(
                tag: "someTag",
                child: Image(
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(
                        "${widget.retoure.imageURL}")),
              )),
            ),
            Text(
              widget.retoure.notes,
              style: TextStyle(
                  fontSize: 24.0,
                  color: _themeChanger.getAppTheme().theme.mainTextColor),
            ),
            Text(
              DateFormat('dd.MM.yyyy').format(widget.retoure.date),
              style: TextStyle(
                  fontSize: 24.0,
                  color: _themeChanger.getAppTheme().theme.mainTextColor),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroPhotoViewWrapper extends StatelessWidget {
  const HeroPhotoViewWrapper(
      {this.imageProvider,
      this.loadingChild,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale});

  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          imageProvider: imageProvider,
          loadingChild: loadingChild,
          backgroundDecoration: backgroundDecoration,
          minScale: minScale,
          maxScale: maxScale,
          heroTag: "someTag",
        ));
  }
}
