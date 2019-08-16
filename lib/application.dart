import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retoure/model/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
  static final Application _application = Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();

  static bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  final List<String> supportedLanguages = [
    "English",
    "Deutsch",
  ];

  final List<String> supportedLanguagesCodes = [
    "en",
    "de",
  ];

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));

  //function to be invoked when changing the language
  LocaleChangeCallback onLocaleChanged;

  static Future<String> getPushToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getString('push_token');
    if (result == null) {
      result = '';
    }
    return result;
  }

  static void savePushToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('push_token', token);

    var id = prefs.getString('id');

    Firestore.instance
        .collection('users')
        .document(id)
        .updateData({'pushToken': token})
        .then((data) async {})
        .catchError((err) {});
  }

  static Future<AppTheme> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var index = (prefs.getInt('theme') ?? 0);
    return myThemes[index];
  }

  static AppTheme getDefaultTheme() {
    return myThemes[0];
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

Application application = Application();

typedef void LocaleChangeCallback(Locale locale);
