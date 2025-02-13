import 'package:emodiary/provider/user_state.dart';
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
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.canvasColor,
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
                    color: theme.colorScheme.secondary,
                  ),
                  SizedBox(height: 10,),
                  // app name
                  Text(
                    'E m o D i a r y',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
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
                  activeThumbColor: theme.colorScheme.secondary,
                  inactiveThumbColor: theme.colorScheme.secondary,
                  onSwipe: () {
                    context.go(userState.loggedIn ? '/home/today' : '/auth/login');
                  },
                  child: Text(
                    'Swipe to start ...',
                    style: TextStyle(
                      fontSize: 15,
                      color: theme.colorScheme.onSurface
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
