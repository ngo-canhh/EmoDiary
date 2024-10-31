import 'package:emodiary/user_state.dart';
import 'package:emodiary/views/register_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Email"),
              controller: emailController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Password"),
              controller: passwordController,
            ),
            SizedBox(height: 16,),
            ElevatedButton(
              onPressed: () {
                try {
                  userState.signIn(emailController.text.trim(), passwordController.text.trim());
                  context.go('/home/today');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login Failed: $e')),
                  );
                }
              },
              child: Text('Sign in'),
            ),
            SizedBox(height: 16,),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}
