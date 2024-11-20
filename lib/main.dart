import 'package:emodiary/auth/user_state.dart';
import 'package:emodiary/firebase_options.dart';
import 'package:emodiary/views/auth/forgot_pw_screen.dart';
import 'package:emodiary/views/auth/login_screen.dart';
import 'package:emodiary/views/home/main_wrapper.dart';
import 'package:emodiary/views/home/me_page.dart';
import 'package:emodiary/views/home/calendar_page.dart';
import 'package:emodiary/views/auth/signup_screen.dart';
import 'package:emodiary/views/splash/splash_screen.dart';
import 'package:emodiary/views/home/today_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

void main() async {
  // Đảm bảo hđ của Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var userState = await UserState.create();

  runApp(ChangeNotifierProvider.value(value: userState, child: App()));
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
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home/today',
              builder: (context, state) => TodayPage(),
            )
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home/calendar',
              builder: (context, state) => CalendarPage(),
            )
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home/me',
              builder: (context, state) => MePage(),
            )
          ]),
        ])
  ],
);

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    UserState userState = Provider.of<UserState>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: userState),
        if (userState.loggedIn)
          ChangeNotifierProvider.value(value: userState.dbProvider),
      ],
      child: MaterialApp.router(
        title: 'EmoDiary',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            dynamicSchemeVariant: DynamicSchemeVariant.content,
            seedColor: Color(0xffcfe1b9),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            dynamicSchemeVariant: DynamicSchemeVariant.content,
            seedColor: Color(0xff728156),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}
