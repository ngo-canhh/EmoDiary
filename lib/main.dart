import 'package:emodiary/theme/dark_mode.dart';
import 'package:emodiary/theme/light_mode.dart';
import 'package:emodiary/user_state.dart';
import 'package:emodiary/firebase_options.dart';
import 'package:emodiary/views/forgot_pw_screen.dart';
import 'package:emodiary/views/login_screen.dart';
import 'package:emodiary/views/main_wrapper.dart';
import 'package:emodiary/views/me_page.dart';
import 'package:emodiary/views/notes_page.dart';
import 'package:emodiary/views/signup_screen.dart';
import 'package:emodiary/views/splash_screen.dart';
import 'package:emodiary/views/today_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(ChangeNotifierProvider(
    create: (context) => UserState(),
    builder: (context, child) => const App(),
  ));
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) {
        // String? signUpBack = state.pathParameters['signUpBack'];
        return LoginScreen(); 
      },
    ),
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => SignupScreen(),
    ),
    GoRoute(
      path: '/auth/forgotpw',
      builder: (context, state) => ForgotPwScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainWrapper(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/today',
              builder: (context, state) => TodayPage(),
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/notes',
              builder: (context, state) => NotesPage(),
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/me',
              builder: (context, state) => MePage(),
            )
          ]
        ),
      ]
    )
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EmoDiary',
      theme: lightMode,
      darkTheme: darkMode,
      routerConfig: _router,
    );
  }
}

