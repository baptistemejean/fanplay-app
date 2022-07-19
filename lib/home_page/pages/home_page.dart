import 'package:fanplay/home_page/pages/leagues/league_create_form.dart';
import 'package:flutter/material.dart';

import '../../components/http_requests.dart';
import '../../loading_page/loading_screen.dart';
import '../home.dart';
import 'leagues/leagues_select.dart';

class HomePage extends StatefulWidget {
  String username;

  HomePage({required this.username});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  var _leagues;
  bool isLeaguesLoading = true;

  @override
  void initState() {
    refresh();

    super.initState();
  }

  void refresh() {
    setState(() {
      isLeaguesLoading = true;
      _leagues = [];
    });

    loadLeagues();
  }

  void loadLeagues() async {
    final result = await LeagueRequests.getLeagues();
    _leagues = result['body'];

    setState(() {
      if (result['exception'].success) {
        isLeaguesLoading = false;
      }
    });
  }

  showJoinDialog() {
    var _formKey = GlobalKey<FormState>();
    var leagueCondensedId = '';

    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text('Enter league\'s secret code'),
              content: Form(
                  key: _formKey,
                  child: TextFormField(
                      decoration: const InputDecoration(
                          label: Text("League code"),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          contentPadding: EdgeInsets.only(left: 12)),
                      style: const TextStyle(fontSize: 16),
                      obscureText: false,
                      enableSuggestions: true,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a code';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        leagueCondensedId = value;
                      })),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pushNamed(LoadingScreen.id);

                      final result =
                          await LeagueRequests.joinLeague(leagueCondensedId);

                      if (result['exception'].success) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.id, (route) => false);
                      }
                    },
                    child: Text('Join league')),
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 80),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 30, left: 20),
            child: Text(
              'Hello, ${widget.username}',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 26),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 5, left: 20),
            child: Text(
              'Your leagues',
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          !isLeaguesLoading && _leagues.isNotEmpty
              ? LeagueSelect(leagues: _leagues)
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
