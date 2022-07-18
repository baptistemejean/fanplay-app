import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TopBar extends StatelessWidget implements PreferredSizeWidget{
  final double _prefferedHeight = 90.0;

  String title;
  List<Color> colors;

  TopBar(this.title, this.colors);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _prefferedHeight,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        boxShadow: [BoxShadow(blurRadius: 2, spreadRadius: 0.5)]
      ),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 30,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
          fontFamily: 'Kanit'
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);
}
