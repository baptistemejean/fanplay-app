import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fanplay/components/http_requests.dart';
import '../../../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyFanplayPage extends StatefulWidget {
  const MyFanplayPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyFanplayPageState();
  }
}

class _MyFanplayPageState extends State<MyFanplayPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextButton(
            onPressed: () async {
              await AuthRequests.logout(context);
            },
            child: const Text(
              'Log out',
              style: TextStyle(decoration: TextDecoration.underline),
            ))
      ],
    );
  }
}
