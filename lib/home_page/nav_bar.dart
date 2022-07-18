import 'dart:ffi';
import 'package:ionicons/ionicons.dart';

import 'home.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  Function(int) itemTappedCallback;

  NavBar({required this.itemTappedCallback});

  @override
  State<StatefulWidget> createState() {
    return NavBarState();
  }
}

class NavBarState extends State<NavBar> {
  var _curIndex = 0;

  NavBarState();

  void _onItemTapped(int index) {
    setState(() {
      _curIndex = index;
    });

    widget.itemTappedCallback(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 26,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      items: [
        BottomNavigationBarItem(
            icon: _curIndex == 0
                ? Icon(Ionicons.home)
                : Icon(Ionicons.home_outline),
            label: "Home",
            backgroundColor: Theme.of(context).colorScheme.background),
        BottomNavigationBarItem(
            icon: _curIndex == 1
                ? Icon(Ionicons.pricetags)
                : Icon(Ionicons.pricetags_outline),
            label: "Shop",
            backgroundColor: Theme.of(context).colorScheme.background),
      ],
      currentIndex: _curIndex,
      onTap: _onItemTapped,
    );
  }
}
