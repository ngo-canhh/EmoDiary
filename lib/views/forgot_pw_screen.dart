import 'package:emodiary/components/auth_textfield.dart';
import 'package:emodiary/user_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:provider/provider.dart';

class ForgotPwScreen extends StatefulWidget {
  const ForgotPwScreen({super.key});

  @override
  State<ForgotPwScreen> createState() => _ForgotPwScreenState();
}

class _ForgotPwScreenState extends State<ForgotPwScreen> {

  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPwController = TextEditingController();


  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    codeController.dispose();
    newPwController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    return OverlayLoaderWithAppIcon(
      isLoading: _isLoading,
      appIcon: Icon(Icons.person),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.featherPointed,
                    size: MediaQuery.of(context).size.width * 0.28,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(height: 5,),
              
                  // app name
                  Text(
                    'E m o D i a r y',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface
                    ),
                  ),
                  SizedBox(height: 40,),


                  // text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          'Enter your email:',
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
              
                  // email textfield
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AuthTextfield(
                            hintText: 'Email', 
                            obscureText: false, 
                            controller: emailController),
                        ),
                      ),
                      
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: GestureDetector(
                            child: Column(
                              children: [
                                Text(
                                  'Send',
                                  style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'OTP',
                                  style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await userState.sendResetPwRequest(context: context, emailController: emailController);
                              setState(() {
                                _isLoading = false;
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  // Divider(
                  //   color: Theme.of(context).colorScheme.inversePrimary,
                  // ),

                  // // otp
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       flex: 8,
                  //       child: Column(
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: AuthTextfield(
                  //               hintText: 'OTP', 
                  //               obscureText: false, 
                  //               controller: codeController),
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: AuthTextfield(
                  //               hintText: 'New password', 
                  //               obscureText: false, 
                  //               controller: newPwController),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                      
                  //     Expanded(
                  //       flex: 2,
                  //       child: Center(
                  //         child: GestureDetector(
                  //           child: Column(
                  //             children: [
                  //               Text(
                  //                 'Confirm',
                  //                 style: TextStyle(
                  //                 color: Theme.of(context).colorScheme.inversePrimary,
                  //                 fontSize: 15,
                  //                 fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //               Text(
                  //                 'OTP',
                  //                 style: TextStyle(
                  //                 color: Theme.of(context).colorScheme.inversePrimary,
                  //                 fontSize: 15,
                  //                 fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //               Text(
                  //                 '&',
                  //                 style: TextStyle(
                  //                 color: Theme.of(context).colorScheme.inversePrimary,
                  //                 fontSize: 15,
                  //                 fontWeight: FontWeight.w300,
                  //                 ),
                  //               ),
                  //               Text(
                  //                 'Reset',
                  //                 style: TextStyle(
                  //                 color: Theme.of(context).colorScheme.inversePrimary,
                  //                 fontSize: 15,
                  //                 fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           onTap: () async {
                  //             setState(() {
                  //               _isLoading = true;
                  //             });
                  //             await userState.confirmOTP(context: context, codeController: codeController, newPwController: newPwController);
                  //             setState(() {
                  //               _isLoading = false;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // SizedBox(height: 5,),


                  // sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Remember your password? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 15
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/auth/login');
                        },
                        child: Text(
                          'Log in!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
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
