import 'package:emodiary/components/auth_textfield.dart';
import 'package:emodiary/user_state.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                    color: colors.inversePrimary,
                  ),
                  SizedBox(height: 5,),
              
                  // app name
                  Text(
                    'E m o D i a r y',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colors.inversePrimary
                    ),
                  ),
                  SizedBox(height: 50,),

              
                  // email textfield
                  AuthTextfield(
                    hintText: 'Email', 
                    obscureText: false, 
                    controller: emailController),

                  SizedBox(height: 10,),


                  // password textfield
                  AuthTextfield(
                    hintText: 'Password', 
                    obscureText: true, 
                    controller: passwordController),

                  SizedBox(height: 5,),


                  // forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.go('/auth/forgotpw');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: colors.secondary,
                            fontSize: 13
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15,),


                  // login 
                  AnimatedButton(
                    text: 'Log in',
                    height: 50,
                    width: 130,
                    borderRadius: 50,
                    borderWidth: 2,
                    isReverse: true,
                    onPress: () {
                      setState(() {
                        _isLoading = true;
                      });
                      userState.logIn(
                        context: context, 
                        emailController: emailController, 
                        passwordController: passwordController);
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


                  // sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: colors.onSecondary,
                          fontSize: 15
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/auth/signup');
                        },
                        child: Text(
                          'Sign up now!',
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
