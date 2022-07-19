import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fanplay/home_page/home.dart';
import 'package:fanplay/home_page/pages/leagues/league_page.dart';
import 'package:fanplay/components/league.dart';
import 'package:fanplay/components/league_preview.dart';
import 'package:fanplay/components/http_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../components/svg_provider.dart' as flutter_svg_provider;
import '../../../components/tokens.dart';

class LeagueContainer extends StatefulWidget {
  League league;
  LeagueContainer({required this.league});

  @override
  State<LeagueContainer> createState() => _LeagueContainerState();
}

class _LeagueContainerState extends State<LeagueContainer> {
  bool _isTokenLoading = true;

  var accessToken;

  @override
  void initState() {
    getToken();

    super.initState();
  }

  void getToken() async {
    accessToken = await Tokens.getToken('access_token');

    setState(() {
      _isTokenLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        elevation: 5,
        shadowColor: Colors.black.withOpacity(1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.only(left: 20, bottom: 10),
        /*decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.onBackground,
              boxShadow: [
                BoxShadow(
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                    color: Color(0xffD5D5D5))
              ]),*/
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: (() {
            Navigator.pushNamed(context, LeaguePage.id, arguments: {
              'id': widget.league.id,
            });
          }),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  widget.league.name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.league.selectedTeam != null && !_isTokenLoading
                      ? Container(
                          height: 90,
                          child: Image(
                            image: flutter_svg_provider.Svg(
                                'http://10.0.2.2:${HttpRequests.PORT}/public/logos/${widget.league.selectedTeam!.franchise.franchiseName}/logo.svg',
                                source: flutter_svg_provider.SvgSource.network,
                                headers: {
                                  "Authorization": "Bearer $accessToken"
                                }),
                          ),
                        )
                      : SizedBox.shrink(),
                  Container(
                    //margin: EdgeInsets.only(right: 20),
                    width: 160,
                    height: 15,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        color: widget.league.selectedTeam != null
                            ? widget.league.selectedTeam!.franchise.colorPrimary
                            : Theme.of(context).colorScheme.secondary,
                        minHeight: 10,
                        value: 0.23,
                        semanticsLabel: "League status",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ))
            ],
          ),
        ));
  }
}
