import 'dart:io';
import 'package:fanplay/home_page/pages/leagues/franchise_select/franchise_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fanplay/auth/auth_page.dart';
import 'package:fanplay/components/assets/buttons.dart';
import 'package:fanplay/components/http_requests.dart';
import 'package:fanplay/home_page/pages/leagues/league_page.dart';
import 'package:fanplay/home_page/pages/leagues/player_auction/player_auction.dart';
import 'package:fanplay/components/league.dart';
import 'package:fanplay/loading_page/loading_screen.dart';
import 'home_page/pages/leagues/league_create_form.dart';
import 'home_page/home.dart';
import 'home_page/nav_bar.dart';
import 'home_page/pages/leagues/league_create_form.dart';
import 'themes/light_theme.dart';
import 'themes/dark_theme.dart';
import 'package:fanplay/components/league_preview.dart';
import 'components/tokens.dart';

void main() {
  runApp(MaterialApp(
      themeMode: ThemeMode.light,
      theme: LightTheme(),
      title: "MyApp",
      home: MyApp(),
      routes: {
        LoadingScreen.id: (context) => LoadingScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        FranchiseSelect.id: (context) => FranchiseSelect(
              leagueId: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['leagueId'],
            ),
        //extract the arguments from the pushNamed call with LeaguePage.id
        LeaguePage.id: (context) => LeaguePage(
              leagueId: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['id'],
            ),
        LeagueCreateForm.id: (context) => LeagueCreateForm(),
        PlayerAuction.id: (context) => PlayerAuction(),
        AuthPage.id: (context) => AuthPage(),
        MyApp.id: (context) => MyApp()
      }));
}

class MyApp extends StatefulWidget {
  static const id = "MyApp";

  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    checkToken() async {
      if (await HttpRequests.tryRefreshToken(context)) {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    }

    checkToken();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome to Fanplay",
            style: TextStyle(
                fontSize: 24, color: Theme.of(context).colorScheme.onSurface),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            margin:
                const EdgeInsets.only(top: 40, bottom: 40, right: 40, left: 40),
            height: 200,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 2,
                  minimumSize: Size(130, 40),
                  maximumSize: Size(180, 40),
                  shadowColor: Color(0xffD5D5D5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              onPressed: () {
                Navigator.of(context).pushNamed(AuthPage.id);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Get started",
                    style: TextStyle(fontSize: 18),
                  ),
                  Icon(
                    Icons.arrow_right_alt_rounded,
                    size: 35,
                  )
                ],
              )),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account ?",
                style: TextStyle(fontSize: 16),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(LoginScreen.id);
                  },
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                        fontSize: 16, decoration: TextDecoration.underline),
                  ))
            ],
          ),*/
        ],
      ),
    );
  }
}
