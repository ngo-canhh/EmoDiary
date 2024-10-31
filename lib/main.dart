import 'package:emodiary/user_state.dart';
import 'package:emodiary/firebase_options.dart';
import 'package:emodiary/views/home_screen.dart';
import 'package:emodiary/views/login_screen.dart';
import 'package:emodiary/views/main_wrapper.dart';
import 'package:emodiary/views/me_page.dart';
import 'package:emodiary/views/notes_page.dart';
import 'package:emodiary/views/splash_screen.dart';
import 'package:emodiary/views/today_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      path: '/login',
      builder: (context, state) => LoginScreen(),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

