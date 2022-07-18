import 'dart:convert';

import 'package:fanplay/loading_page/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:fanplay/components/league_preview.dart';
import 'package:fanplay/home_page/home.dart';
import 'package:flutter/rendering.dart';
import 'package:ionicons/ionicons.dart';
import 'league_create_form.dart';
import 'package:fanplay/components/franchise.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fanplay/components/league.dart';
import 'package:fanplay/components/http_requests.dart';
import 'league_container.dart';
import 'package:http/http.dart' as http;

class LeagueSelect extends StatefulWidget {
  List<League> leagues;

  LeagueSelect({Key? key, required this.leagues}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LeagueSelectState();
  }
}

class _LeagueSelectState extends State<LeagueSelect> {
  @override
  Widget build(BuildContext context) {
    Color transparentPrimary =
        Theme.of(context).colorScheme.primary.withAlpha(255);
    return Container(
      height: 150,
      alignment: Alignment.centerLeft,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          for (var i in widget.leagues)
            for (var j in i.teams)
              LeagueContainer(
                league: i.withSelectedTeam(j),
              )
        ],
      ),
    );
  }
}

/*Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Your leagues',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),*/
