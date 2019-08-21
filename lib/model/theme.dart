import 'package:flutter/material.dart';

import '../ui/utils/application.dart';

class MyTheme {
  Brightness brightness;
  Color backgroundColor;
  Color scaffoldBackgroundColor;
  Color primaryColor;
  Color cardColor;
  Color splashColor;
  Brightness primaryColorBrightness;
  Color accentColor;
  Color mainTextColor;
  Color mainBackgroundColor;
  Color cardBackgroundColor;
  Color highlightColor;

  MyTheme(
      {this.brightness,
      this.backgroundColor,
      this.scaffoldBackgroundColor,
      this.primaryColor,
      this.primaryColorBrightness,
      this.cardColor,
      this.splashColor,
      this.mainTextColor,
      this.mainBackgroundColor,
      this.cardBackgroundColor,
      this.highlightColor,
      this.accentColor});
}

class AppTheme {
  String name;
  MyTheme theme;

  AppTheme(this.name, this.theme);
}

buildThemeData(AppTheme appTheme) {
  return ThemeData(
    brightness: appTheme.theme.brightness,
    backgroundColor: appTheme.theme.backgroundColor,
    scaffoldBackgroundColor: appTheme.theme.scaffoldBackgroundColor,
    primaryColor: appTheme.theme.primaryColor,
    primaryColorBrightness: appTheme.theme.primaryColorBrightness,
    accentColor: appTheme.theme.accentColor,
    splashColor: appTheme.theme.splashColor,
    highlightColor: appTheme.theme.highlightColor,
  );
}

List<AppTheme> myThemes = [
  AppTheme(
      'Light',
      MyTheme(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: HexColor("#60A8A4"),
        mainBackgroundColor: Colors.white,
        cardBackgroundColor: Colors.white,
        primaryColorBrightness: Brightness.dark,
        accentColor: HexColor("#60A8A4"),
        mainTextColor: Colors.black,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      )),
  AppTheme(
    'Dark',
    MyTheme(
      brightness: Brightness.dark,
      backgroundColor: HexColor("212121"),
      accentColor: HexColor("#60A8A4"),
      mainBackgroundColor: HexColor("303030"),
      mainTextColor: Colors.white,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    ),
  ),
];
