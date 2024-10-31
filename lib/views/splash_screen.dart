import 'package:emodiary/user_state.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});  
  @override
  Widget build(BuildContext context) {

    UserState userState = Provider.of<UserState>(context);
    Future.delayed(Duration(seconds: 1), () {
      if (context.mounted) {
        context.go(userState.loggedIn ? '/home/today' : '/login');
      }
    });

    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        alignment: Alignment.center,
        child: Icon(Icons.local_convenience_store_rounded),
      ),
    );
  }

}
