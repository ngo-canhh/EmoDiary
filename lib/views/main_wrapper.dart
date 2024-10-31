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
    return Scaffold(
      body: SafeArea(
        child: widget.navigationShell,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _goBranch(_selectedIndex);
        },
        buttonBackgroundColor: Theme.of(context).highlightColor,
        color: Theme.of(context).highlightColor,
        backgroundColor: Theme.of(context).canvasColor,
        items: [
            FaIcon(FontAwesomeIcons.faceSmileWink, color: Theme.of(context).iconTheme.color,),
            FaIcon(FontAwesomeIcons.calendarDays, color: Theme.of(context).iconTheme.color,),
            FaIcon(FontAwesomeIcons.user, color: Theme.of(context).iconTheme.color,),
        ],
        height: 60,
        animationCurve: Curves.fastLinearToSlowEaseIn,
      )
    );
  }
}