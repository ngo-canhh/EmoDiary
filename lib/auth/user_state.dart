import 'package:emodiary/auth/firebase_exceptions.dart';
import 'package:emodiary/database/db_provider.dart';
import 'package:emodiary/helper/helper_function.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    }
    return userState;
  }

  User? _user;
  DbProvider? _dbProvider;
  static final auth = FirebaseAuth.instance;


  DbProvider? get dbProvider => _dbProvider;
  bool get loggedIn => _user != null;
  User? get user => _user;


  

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
                      required TextEditingController emailController}) async {
    AuthStatus? status;
    await auth
        .sendPasswordResetEmail(email: emailController.text)
        .then((value) => status = AuthStatus.successful)
        .catchError(
          (e) => status = AuthExceptionHandler.handleAuthException(e));
    if (status == AuthStatus.successful) {
      await displayMessageToUser("Successful! Check your email!", context);
    } else {
      await displayMessageToUser(AuthExceptionHandler.generateErrorMessage(status), context);
    }
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