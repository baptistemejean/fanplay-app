import 'dart:convert';
import 'package:fanplay/components/league.dart';
import 'package:fanplay/home_page/pages/leagues/player_auction/player_auction.dart';
import 'package:flutter/material.dart';
import 'league_create_form.dart';
import 'package:fanplay/components/franchise.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fanplay/components/league_preview.dart';
import 'package:fanplay/components/http_requests.dart';
import 'league_container.dart';
import 'franchise_select/franchise_select.dart';
import 'package:http/http.dart' as http;

class LeaguePage extends StatefulWidget {
  static const id = 'LeaguePage';

  String leagueId;
  LeaguePage({required this.leagueId});

  @override
  State<StatefulWidget> createState() {
    return _LeaguePageState();
  }
}

class _LeaguePageState extends State<LeaguePage> {
  int _curIndex = 1;

  var _league;
  bool isLeagueLoading = true;

  List<Widget?> pages = [null, PlayerAuction(), null, null];

  @override
  void initState() {
    loadLeague();

    super.initState();
  }

  void loadLeague() async {
    final result = await LeagueRequests.getLeague(widget.leagueId);

    if (result['exception'].success) {
      _league = result['body'];
    }

    setState(() {
      isLeagueLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _curIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color transparentPrimary =
        Theme.of(context).colorScheme.primary.withAlpha(255);
    return !isLeagueLoading
        ? _league.teams.isEmpty
            ? FranchiseSelect(
                leagueId: _league.id, isPrivate: _league.isPrivate)
            : DefaultTabController(
                initialIndex: 1,
                length: 4,
                child: Scaffold(
                    appBar: AppBar(
                      iconTheme: IconThemeData(color: Colors.white),
                      elevation: 0,
                      leading: IconButton(
                        splashRadius: 17,
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 21,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      title: Text(
                        _league.name,
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      centerTitle: true,
                      bottom: TabBar(
                        indicatorColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 3,
                        splashBorderRadius: BorderRadius.circular(10),
                        tabs: const [
                          Tab(
                            height: 40,
                            /*icon: Icon(Icons.schedule, size: 20,), */ text:
                                "Games",
                          ),
                          Tab(
                            height: 40,
                            icon: Icon(
                              Icons.work_rounded,
                              size: 20,
                            ),
                          ),
                          Tab(
                            height: 40,
                            icon: Icon(
                              Icons.leaderboard_rounded,
                              size: 20,
                            ),
                          ),
                          Tab(
                            height: 40,
                            icon: Icon(
                              Icons.settings_rounded,
                              size: 20,
                            ),
                          ),
                        ],
                        onTap: _onItemTapped,
                      ),
                    ),
                    body: pages[_curIndex]),
              )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ),
          );
  }
}
