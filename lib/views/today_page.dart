import 'package:emodiary/user_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserState userState = Provider.of<UserState>(context);

    return Text('${userState.loggedIn}');
  }
  
}
