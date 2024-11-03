import 'package:emodiary/components/auth_textfield.dart';
import 'package:emodiary/user_state.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPwController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final userState = Provider.of<UserState>(context);
    return OverlayLoaderWithAppIcon(
      isLoading: _isLoading,
      appIcon: Icon(Icons.person),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.featherPointed,
                    size: MediaQuery.of(context).size.width * 0.28,
                    color: colors.onSurface,
                  ),
                  SizedBox(height: 5,),
              
                  // app name
                  Text(
                    'E m o D i a r y',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface
                    ),
                  ),
                  SizedBox(height: 50,),
              
                  // email textfield
                  AuthTextfield(
                    hintText: 'Email', 
                    obscureText: false, 
                    controller: emailController),
                  SizedBox(height: 10,),


                  // username
                  AuthTextfield(
                    hintText: 'Username', 
                    obscureText: false, 
                    controller: usernameController),
                  SizedBox(height: 10,),

                  // password textfield
                  AuthTextfield(
                    hintText: 'Password', 
                    obscureText: true, 
                    controller: passwordController),
                  SizedBox(height: 10,),

                  // confirm password
                  AuthTextfield(
                    hintText: 'Confirm password', 
                    obscureText: true, 
                    controller: confirmPwController),
                  SizedBox(height: 15,),

                  // sign up 
                  AnimatedButton(
                    text: 'Sign up',
                    height: 50,
                    width: 130,
                    borderRadius: 50,
                    borderWidth: 2,
                    isReverse: true,
                    onPress: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await userState.signUp(
                        context: context, 
                        emailController: emailController, 
                        userNameController: usernameController,
                        passwordController: passwordController,
                        confirmPwController: confirmPwController);
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    textStyle: TextStyle(
                      color: colors.inversePrimary,
                      fontSize: 20,
                    ),
                    backgroundColor: colors.primary,
                    selectedTextColor: colors.primary,
                    selectedBackgroundColor: colors.inversePrimary,
                    transitionType: TransitionType.CENTER_ROUNDER,
                  ),
                  SizedBox(height: 10,),


                  // log in
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: colors.onSecondary,
                          fontSize: 15
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/auth/login');
                        },
                        child: Text(
                          'Log in now!',
                          style: TextStyle(
                            color: colors.inversePrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
