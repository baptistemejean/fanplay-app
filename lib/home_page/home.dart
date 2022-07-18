import 'dart:convert';
import 'package:fanplay/components/assets/background_container.dart';
import 'package:fanplay/components/http_requests.dart';
import 'package:fanplay/home_page/pages/home_page.dart';
import 'package:fanplay/home_page/pages/leagues/league_create_form.dart';
import 'package:flutter/material.dart';
import 'package:fanplay/main.dart';
import 'package:ionicons/ionicons.dart';
import '../components/user.dart';
import 'nav_bar.dart';
import 'top_bar.dart';
import 'pages/my_fanplay/my_fanplay_page.dart';
import 'pages/leagues/leagues_select.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "HomeScreen";

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _curIndex = 0;

  User? _user;
  bool _isUserLoading = true;

  @override
  void initState() {
    loadUser();

    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _curIndex = index;
    });
  }

  void loadUser() async {
    _isUserLoading = true;

    final result = await AuthRequests.getUser();

    if (result['exception'].success) {
      _user = result['body'];

      setState(() {
        _isUserLoading = false;
      });
    }
  }

  List<Widget> screens(User user) {
    return [
      HomePage(
        username: user.username,
      ),
      Center(child: Text("Shop")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () => false,
            child: Row(children: [
              Icon(
                Ionicons.flash,
                color: Colors.white,
              ),
              Text(
                "0",
                style: TextStyle(color: Colors.white),
              )
            ]),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(children: [
        Background(),
        !_isUserLoading
            ? screens(_user!)[_curIndex]
            : Center(
                child: CircularProgressIndicator(
                strokeWidth: 3,
              )),
      ]),
      bottomNavigationBar: NavBar(
        itemTappedCallback: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        onPressed: (() {
          Navigator.of(context).pushNamed(LeagueCreateForm.id);
        }),
        child: Icon(Ionicons.add, size: 40),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
