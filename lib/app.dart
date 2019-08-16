import 'package:flutter/material.dart';
import 'package:retoure/ui/screens/forgot_password.dart';
import 'package:retoure/ui/screens/home.dart';
import 'package:retoure/ui/screens/sign_in.dart';
import 'package:retoure/ui/screens/sign_up.dart';
import 'package:retoure/ui/utils/theme_changer.dart';
import 'package:provider/provider.dart';

import 'model/theme.dart';

class RetoureApp extends StatefulWidget {
  RetoureApp({this.selectedTheme});

  final AppTheme selectedTheme;

  @override
  _RetoureAppState createState() => _RetoureAppState(thisTheme: selectedTheme);
}

class _RetoureAppState extends State<RetoureApp> {
  _RetoureAppState({this.thisTheme});

  final AppTheme thisTheme;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      builder: (_) => ThemeChanger(thisTheme),
      child: MaterialApp(
        title: 'Retoure',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => HomeScreen(),
          '/signin': (context) => SignInScreen(),
          '/signup': (context) => SignUpScreen(),
          '/forgot-password': (context) => ForgotPasswordScreen(),
        },
      ),
    );
  }
}
