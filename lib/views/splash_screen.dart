import 'package:emodiary/user_state.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});  
  @override
  Widget build(BuildContext context) {

    UserState userState = Provider.of<UserState>(context);
    ColorScheme colors = Theme.of(context).colorScheme;

    // delay
    // Future.delayed(Duration(seconds: 2), () {
    //   if (context.mounted) {
    //     context.go(userState.loggedIn ? '/home/today' : '/auth/login');
    //   }
    // });

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: Column(
          children: [
            
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  FaIcon(
                    FontAwesomeIcons.featherPointed,
                    size: MediaQuery.of(context).size.width * 0.3,
                    color: colors.inversePrimary,
                  ),
                  SizedBox(height: 10,),
                  // app name
                  Text(
                    'E m o D i a r y',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colors.inversePrimary
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                child: SwipeButton.expand(
                  activeThumbColor: colors.secondary,
                  onSwipeEnd: () {
                    context.go(userState.loggedIn ? '/home/today' : '/auth/login');
                  },
                  child: Text(
                    'Swipe to start ...',
                    style: TextStyle(
                      fontSize: 15,
                      color: colors.inversePrimary
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
