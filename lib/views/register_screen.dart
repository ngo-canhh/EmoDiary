import 'package:emodiary/user_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget{
  RegisterScreen({super.key});
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
              onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                try {
                  await userState.createUser(email, password);
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Success. Please login!')),
                  );
                  navigator.pop();
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Register Failed: $e')),
                  );
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}