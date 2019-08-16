import 'package:firebase_auth/firebase_auth.dart';
import 'package:retoure/model/settings.dart';
import 'package:retoure/model/user.dart';

class StateModel {
  bool isLoading;
  FirebaseUser firebaseUserAuth;
  User user;
  Settings settings;

  StateModel({
    this.isLoading = false,
    this.firebaseUserAuth,
    this.user,
    this.settings,
  });
}
