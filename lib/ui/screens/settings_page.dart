import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:retoure/model/theme.dart';
import 'package:retoure/ui/utils/application.dart';
import 'package:retoure/ui/utils/theme_changer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  SettingsPageState createState() {
    return new SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  String version;
  String buildNumber;

  _getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  void initState() {
    super.initState();

    _getVersionNumber();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      backgroundColor: _themeChanger.getAppTheme().theme.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: _themeChanger.getAppTheme().theme.mainTextColor),
        brightness: _themeChanger.getAppTheme().theme.brightness,
        backgroundColor: _themeChanger.getAppTheme().theme.mainBackgroundColor,
        title: Text(
          "Einstellungen",
          style: TextStyle(
              fontSize: 24.0,
              color: _themeChanger.getAppTheme().theme.mainTextColor),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("Theme",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 24.0,
                        color:
                            _themeChanger.getAppTheme().theme.mainTextColor)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                        child: Text(
                          "Dunkel",
                          style: TextStyle(
                              color: _themeChanger
                                  .getAppTheme()
                                  .theme
                                  .mainTextColor),
                        ),
                        color: _themeChanger
                            .getAppTheme()
                            .theme
                            .mainBackgroundColor,
                        textColor: Colors.white,
                        onPressed: () => _saveThemeIndex(_themeChanger, 1)),
                    RaisedButton(
                        color: _themeChanger
                            .getAppTheme()
                            .theme
                            .mainBackgroundColor,
                        textColor: Colors.white,
                        child: Text(
                          "Hell",
                          style: TextStyle(
                              color: _themeChanger
                                  .getAppTheme()
                                  .theme
                                  .mainTextColor),
                        ),
                        onPressed: () => _saveThemeIndex(_themeChanger, 0)),
                  ],
                ),
                Text("Sprache",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 24.0,
                        color:
                            _themeChanger.getAppTheme().theme.mainTextColor)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                        child: Text(
                          "Englisch",
                          style: TextStyle(
                              color: _themeChanger
                                  .getAppTheme()
                                  .theme
                                  .mainTextColor),
                        ),
                        color: _themeChanger
                            .getAppTheme()
                            .theme
                            .mainBackgroundColor,
                        textColor: Colors.white,
                        onPressed: () => _setLanguage("en")),
                    RaisedButton(
                        color: _themeChanger
                            .getAppTheme()
                            .theme
                            .mainBackgroundColor,
                        textColor: Colors.white,
                        child: Text(
                          "Deutsch",
                          style: TextStyle(
                              color: _themeChanger
                                  .getAppTheme()
                                  .theme
                                  .mainTextColor),
                        ),
                        onPressed: () => _setLanguage("de")),
                  ],
                ),
              ],
            ),
            new Expanded(
              child: new Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Version: ' + version + '    Build: ' + buildNumber,
                    style: TextStyle(
                        color: _themeChanger.getAppTheme().theme.mainTextColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _setLanguage(String locale) async {
    Application().onLocaleChanged(Locale(locale));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
  }

  _saveThemeIndex(ThemeChanger themeChanger, int id) async {
    themeChanger.setTheme(myThemes[id]);

    if (id == 0) {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', id);
  }
}
