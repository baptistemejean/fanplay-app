import 'dart:convert';
import 'package:fanplay/components/assets/background_container.dart';
import 'package:flutter/material.dart';
import 'package:fanplay/components/http_exception.dart';
import 'package:fanplay/loading_page/loading_screen.dart';
import 'package:ionicons/ionicons.dart';
import '../home_page/home.dart';
import './forms/login_form.dart';
import './forms/sign_up_form.dart';
import 'package:fanplay/components/account.dart';
import 'package:fanplay/components/http_requests.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  static const String id = "AuthPage";

  @override
  State<StatefulWidget> createState() {
    return AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  var _curIndex = 1;

  /*final TabController _controller =
      TabController(length: 2, vsync: SingleTickerProviderStateMixin.);*/

  Future<HttpException?> submitLoginForm(String email, String username,
      String password, BuildContext context) async {
    Navigator.of(context).pushNamed(LoadingScreen.id);

    final result = await AuthRequests.login(email, username, password);

    if (result['exception'].success) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.id, (route) => false);
    } else {
      Navigator.pop(context);

      return result['exception'] as HttpException;
    }
  }

  Future<HttpException?> submitSignupForm(String email, String username,
      String password, BuildContext context) async {
    Navigator.of(context).pushNamed(LoadingScreen.id);

    final result = await AuthRequests.signup(email, username, password);

    if (result['exception'].success) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.id, (route) => false);
    } else {
      Navigator.pop(context);

      return result['exception'] as HttpException;
    }
  }

  List<Widget> forms(BuildContext context) {
    return [LoginForm(submitLoginForm), SignUpForm(submitSignupForm)];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: DefaultTabController(
            initialIndex: 1,
            length: 2,
            child: Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  foregroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.white),
                  leading: IconButton(
                    splashRadius: 17,
                    icon: const Icon(
                      Ionicons.arrow_back,
                      size: 21,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: TabBar(
                    padding: EdgeInsets.only(left: 160),
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 2,
                    //labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Colors.white,
                    splashBorderRadius: BorderRadius.circular(10),
                    tabs: const [
                      Tab(
                        height: 30,
                        /*icon: Icon(Icons.schedule, size: 20,), */ text:
                            "Log in",
                      ),
                      Tab(
                        height: 30,
                        /*icon: Icon(Icons.schedule, size: 20,), */ text:
                            "Sign up",
                      ),
                    ],
                    onTap: (index) {
                      setState(() {
                        _curIndex = index;
                      });
                    },
                  ),
                  /*actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(SignUpScreen.id);
                      },
                      child: const Text("Sign up",
                          style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              color: Colors.white))),
                  TextButton(
                      onPressed: () {
                        //Navigator.pushNamed(context, SignUpScreen.id);
                      },
                      child: const Text("Forgot password ?",
                          style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              color: Colors.white))),
                ],*/
                ),
                body: Stack(
                  children: [AuthBackground(), forms(context)[_curIndex]],
                ))),
        onWillPop: () async => true);
  }
}
