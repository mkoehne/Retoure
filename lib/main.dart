import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retoure/ui/utils/state_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'model/theme.dart';

// - StateWidget incl. state data
//    - RetoureApp
//        - All other widgets which are able to access the data
Future<Null> main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var index = (prefs.getInt('theme') ?? 0);

  if (index == 0) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white10, // navigation bar color
      statusBarColor: Colors.white10, // status bar color
    ));
  } else {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black87, // navigation bar color
      statusBarColor: Colors.black87, // status bar color
    ));
  }
  StateWidget stateWidget =
      new StateWidget(child: new RetoureApp(selectedTheme: myThemes[index]));
  runApp(stateWidget);
}
