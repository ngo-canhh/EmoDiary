import 'package:emodiary/user_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    UserState userState = Provider.of<UserState>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('hello ${ userState.user!.displayName}'),
          ElevatedButton(
            onPressed: () async {
              await userState.logOut(context: context);
            },
            child: Text('Sign Out'),
          )
        ],
      ),
    );
  }
}
