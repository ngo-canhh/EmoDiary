import 'package:emodiary/auth/firebase_exceptions.dart';
import 'package:emodiary/provider/db_provider.dart';
import 'package:emodiary/helper/helper_function.dart';

import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserState extends ChangeNotifier {
  UserState._() {
    init();
  }
  UserState() {
    init();
  }

  init() {
    _user = auth.currentUser;
    FirebaseAuth.instance
                .authStateChanges()
                .listen((User? user) {
                  _user = user;
                });

  }

  static Future<UserState> create() async {
    var userState = UserState._();
    if (userState.loggedIn) {
      userState._dbProvider = await DbProvider.create(user: userState.user!);
      // userState._musicProvider = await MusicProvider.create();
    }

    userState._prefs = await SharedPreferences.getInstance();
    userState.setThemeMode(userState._prefs.getString('themeMode'));
    userState.setLightModeColor(Color(userState._prefs.getInt('colorValue') ?? 0xffcfe1b9));;
    return userState;
  }

  User? _user;
  DbProvider? _dbProvider;
  // MusicProvider? _musicProvider;
  static final auth = FirebaseAuth.instance;
  late ThemeMode _themeMode;
  late String _themeModeStr;
  late Color _color;
  late SharedPreferences _prefs;

  Color get color => _color;
  String get themeModeStr => _themeModeStr;
  ThemeMode get themeMode => _themeMode;
  DbProvider? get dbProvider => _dbProvider;
  // MusicProvider? get musicProvider => _musicProvider;
  bool get loggedIn => _user != null;
  User? get user => _user;

  Future<void> setLightModeColor(Color value) async {
    _color = value;
    notifyListeners();
    await _prefs.setInt('colorValue', value.value);
  }


  Future<void> setThemeMode(String? theme) async {
    switch (theme) {
      case 'system':
      case null:
      _themeMode = ThemeMode.system;
      break;

      case 'light':
      _themeMode = ThemeMode.light;
      break;

      case 'dark':
      _themeMode = ThemeMode.dark;
      break;

      default:
      throw Exception('Input error');
    }
    _themeModeStr = theme ?? 'system';
    await _prefs.setString('themeMode', theme ?? 'system');
    notifyListeners();
  }

  

  // sign in
  Future<void> logIn({required BuildContext context, 
                      required TextEditingController emailController, 
                      required TextEditingController passwordController}) async {
    AuthStatus? status;
    await auth
        .signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
        .then((value) => status = AuthStatus.successful)
        .catchError(
          (e) => status = AuthExceptionHandler.handleAuthException(e));
    if (status == AuthStatus.successful) {
      _dbProvider = await DbProvider.create(user: _user!);
      // _musicProvider = await MusicProvider.create();
      notifyListeners();
      context.go('/home/today');
    } else {
      displayMessageToUser(AuthExceptionHandler.generateErrorMessage(status), context);
      passwordController.clear();
    }
  }

  // sign out
  Future<void> logOut({required BuildContext context}) async {
    AuthStatus? status;
    await auth
        .signOut()
        .then((value) => status = AuthStatus.successful)
        .catchError(
          (e) => status = AuthExceptionHandler.handleAuthException(e));
    if (status == AuthStatus.successful) {
      context.go('/');
    } else {
      await displayMessageToUser(AuthExceptionHandler.generateErrorMessage(status), context);
    }
  }

  // sign up
  Future<void> signUp({required BuildContext context, 
                      required TextEditingController userNameController, 
                      required TextEditingController emailController, 
                      required TextEditingController passwordController, 
                      required TextEditingController confirmPwController}) async {

    if (passwordController.text != confirmPwController.text) {
      throw FirebaseAuthException(
        code: "password-do-not-match"
      );
    }
    AuthStatus? status;
    await auth
        .createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
        .then((value) => status = AuthStatus.successful)
        .catchError(
          (e) => status = AuthExceptionHandler.handleAuthException(e));
    if (status == AuthStatus.successful) {
      await _user!.updateDisplayName(userNameController.text);
      await auth.signOut();
      await displayMessageToUser("Successful, please log in!", context);
      context.go('/auth/login');
    } else {
      await displayMessageToUser(AuthExceptionHandler.generateErrorMessage(status), context);
    }
  }


  // reset password
  Future<void> sendResetPwRequest({required BuildContext context, 
                      required String email}) async {
    AuthStatus? status;
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => status = AuthStatus.successful)
        .catchError(
          (e) => status = AuthExceptionHandler.handleAuthException(e));
    if (status == AuthStatus.successful) {
      await displayMessageToUser("Successful! Check your email!", context);
    } else {
      await displayMessageToUser(AuthExceptionHandler.generateErrorMessage(status), context);
    }
  }

  Future<void> setUserName(String username) async {
    await _user!.updateDisplayName(username);
    await _user!.reload();
    _user = auth.currentUser!;
    notifyListeners();
  }

  Future<bool> changePassword(BuildContext context, String newPassword) async {
    AuthStatus? status;
    await _user!
      .updatePassword(newPassword)
      .then((_) => status = AuthStatus.successful)
      .catchError(
        (e) => status = AuthExceptionHandler.handleAuthException(e)
      );

    if (status == AuthStatus.successful) {
      await displayMessageToUser("Successful!", context);
      await _user!.reload();
    } else {
      await displayMessageToUser(AuthExceptionHandler.generateErrorMessage(status), context);
    }
    return status == AuthStatus.successful;
  }

  // Future<void> confirmOTP({required BuildContext context, 
  //                     required TextEditingController codeController,
  //                     required TextEditingController newPwController}) async {
  //   AuthStatus? status;
  //   await auth
  //       .confirmPasswordReset(code: codeController.text, newPassword: newPwController.text)
  //       .then((value) => status = AuthStatus.successful)
  //       .catchError(
  //         (e) => status = AuthExceptionHandler.handleAuthException(e));
  //   if (status == AuthStatus.successful) {
  //   } else {
  //     displayMessageToUser(AuthExceptionHandler.generateErrorMessage(status), context);
  //   }
  // }

  // change password

  // change username

  // change avatar
}