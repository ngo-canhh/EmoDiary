import 'package:easy_radio/easy_radio.dart';
import 'package:emodiary/provider/user_state.dart';
import 'package:emodiary/components/stateful_textfield.dart';
import 'package:emodiary/provider/db_provider.dart';
import 'package:emodiary/views/me/tag_manager.dart';
import 'package:emodiary/helper/helper_function.dart';
import 'package:emodiary/views/me/me_tile.dart';
import 'package:emodiary/views/me/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      appBar: AppBar(
        title: Text(
          'Setting',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
        // backgroundColor: theme.colorScheme.primary,
      ),
      body: ListView(
        children: [
          ProfileCard(
              // avatarUrl:
              //     'https://scontent.fhan14-3.fna.fbcdn.net/v/t39.30808-6/464620109_1875738602919243_3128987228413772702_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeFiVDmKjlWz6JjJNA9Tfcg0x4Hm8h4V1HLHgebyHhXUcrAE8ZOFA8cJN8x6wCdYJZQ3IiTzcdQChP05aYMu5_ZV&_nc_ohc=TuHwdGhdpmwQ7kNvgGBrI3h&_nc_zt=23&_nc_ht=scontent.fhan14-3.fna&_nc_gid=AYm0upTy_sZXCHyx73b3pfX&oh=00_AYCawiuqlzfibtNZKpAZNIIKRUKHll4OA6uER0bIuHJTyw&oe=67449F54',
              name: userState.user!.displayName!,
              email: userState.user!.email!),
          SizedBox(
            height: 20,
          ),
          MeTile(
              leading: 'Account',
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Change username'),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              _handleChangeUsername(userState);
                            },
                            icon: FaIcon(FontAwesomeIcons.penToSquare))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Change password'),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              _handleChangePassWord(userState);
                            },
                            icon: FaIcon(FontAwesomeIcons.penToSquare))
                      ],
                    ),
                  ),
                ],
              )),
          MeTile(
              leading: 'Tag',
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Tag manager'),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              _handleTagManager();
                            },
                            icon: FaIcon(FontAwesomeIcons.tags))
                      ],
                    ),
                  ),
                ],
              )),
          MeTile(
              leading: 'Theme',
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Change light color'),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          _handleColorPicker(userState);
                        },
                        icon: FaIcon(FontAwesomeIcons.palette),
                        // iconSize: 15,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 22, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Dark Mode'),
                      Spacer(),
                      EasyRadio<String>(
                        value: 'dark',
                        groupValue: userState.themeModeStr,
                        onChanged: (value) async {
                          await userState.setThemeMode(value!);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(right: 22, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Light Mode'),
                      Spacer(),
                      EasyRadio<String>(
                        value: 'light',
                        groupValue: userState.themeModeStr,
                        onChanged: (value) async {
                          await userState.setThemeMode(value!);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(right: 22, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('System Mode'),
                      Spacer(),
                      EasyRadio<String>(
                        value: 'system',
                        groupValue: userState.themeModeStr,
                        onChanged: (value) async {
                          await userState.setThemeMode(value!);
                        },
                      ),
                    ],
                  ),
                ),
              ])),
          ElevatedButton(onPressed: () async {
            await Provider.of<DbProvider>(context, listen: false).deleteUserData();
          }, child: Text('Delete all data')),
        ],
      ),
    );
  }

  void _handleChangePassWord(UserState userState) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Change password'),
            content: StatefulTextfield(
              fields: ['New password', 'Confirm password'],
              onSubmit: (controllers, fields) async {
                if (controllers['New password']!.text !=
                    controllers['Confirm password']!.text) {
                  displayMessageToUser('Password not match', context);
                  controllers['Confirm password']!.clear();
                } else {
                  bool success = await userState.changePassword(
                      context, controllers['New password']!.text);
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    controllers['New password']!.clear();
                    controllers['Confirm password']!.clear();
                  }
                }
              },
              obscureText: true,
            ),
          );
        });
  }

  _handleTagManager() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TagManager(),
        ));
  }

  void _handleChangeUsername(UserState userState) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Change Username'),
            content: StatefulTextfield(
              fields: ['New username'],
              onSubmit: (controllers, fields) {
                userState.setUserName(controllers['New username']!.text);
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  void _handleColorPicker(UserState userState) async {
    Color pickerColor = userState.color;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Main color'),
          content: SingleChildScrollView(
              child: MaterialPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (value) {
                    setState(() {
                      pickerColor = value;
                    });
                  })),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  userState.setLightModeColor(pickerColor);
                  Navigator.pop(context);
                },
                child: Text('Got it'))
          ],
        );
      },
    );
  }
}
