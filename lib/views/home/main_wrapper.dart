import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({
    required this.navigationShell,
    super.key,
  });
  final StatefulNavigationShell navigationShell;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _goBranch(_selectedIndex);
        },
        buttonBackgroundColor: theme.colorScheme.primaryContainer,
        color: theme.colorScheme.primaryContainer,
        backgroundColor: theme.scaffoldBackgroundColor,
        items: [
            FaIcon(FontAwesomeIcons.faceSmileWink, color: theme.colorScheme.onPrimaryContainer,),
            FaIcon(FontAwesomeIcons.calendarDays, color: theme.colorScheme.onPrimaryContainer,),
            FaIcon(FontAwesomeIcons.user, color: theme.colorScheme.onPrimaryContainer,),
        ],
        animationCurve: Curves.fastLinearToSlowEaseIn,
      )
    );
  }
}