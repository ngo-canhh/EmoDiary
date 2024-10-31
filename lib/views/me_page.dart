import 'package:go_router/go_router.dart';
import 'package:emodiary/user_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    UserState userState = Provider.of<UserState>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            userState.signOut();
            context.go('/');
          },
          child: Text('Sign Out'),
        )
      ],
    );
  }
}
