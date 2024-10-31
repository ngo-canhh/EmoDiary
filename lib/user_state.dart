import 'package:emodiary/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class UserState extends ChangeNotifier{
  UserState() {
    init();
  }

  bool _loggedIn = false;
  User? _user;
  
  bool get loggedIn => _loggedIn;
  User? get user1 => _user;

  Future<void> init() async {
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      _loggedIn = true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      _loggedIn = false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUser(String email, String password) async {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }
  
}