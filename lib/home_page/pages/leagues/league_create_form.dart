import 'dart:convert';

import 'package:fanplay/home_page/pages/leagues/franchise_select/franchise_select.dart';
import 'package:fanplay/home_page/pages/leagues/league_page.dart';
import 'package:fanplay/loading_page/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:fanplay/home_page/home.dart';
import 'package:fanplay/components/franchise.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fanplay/components/league_preview.dart';
import 'package:fanplay/components/http_requests.dart';
import 'package:http/http.dart' as http;

class LeagueCreateForm extends StatefulWidget {
  static const id = 'LeagueCreateForm';

  @override
  State<StatefulWidget> createState() {
    return _LeagueCreateFormState();
  }
}

enum Security { public, private }

class _LeagueCreateFormState extends State<LeagueCreateForm> {
  final _formKey = GlobalKey<FormState>();

  var _leagueName = '';

  String dropdownValue = 'Public';
  bool _isPrivate = false;

  Security? _security = Security.public;
  bool _isSingleTeam = false;

  int _currentForm = 0;

  List<Form> forms(BuildContext context, GlobalKey<FormState> formKey) => [
        Form(
            key: formKey,
            child: Container(
              alignment: Alignment.centerLeft,
              width: 300,
              height: 70,
              child: TextFormField(
                initialValue: _leagueName,
                decoration: const InputDecoration(
                    label: Text("Name"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    contentPadding: EdgeInsets.all(8)),
                style: const TextStyle(
                  fontSize: 14,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }

                  return null;
                },
                onChanged: (value) {
                  _leagueName = value;
                },
              ),
            )),
        Form(
            key: formKey,
            child: Container(
              alignment: Alignment.centerLeft,
              width: 300,
              height: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: ListTile(
                        subtitle: Text(
                          "Everyone can join",
                          style: TextStyle(color: Color(0xff777777)),
                        ),
                        minVerticalPadding: 0,
                        dense: true,
                        horizontalTitleGap: 1,
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          "Public",
                          style: TextStyle(fontSize: 14),
                        ),
                        leading: Radio<Security>(
                          fillColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                          value: Security.public,
                          groupValue: _security,
                          onChanged: (Security? value) {
                            setState(() {
                              _security = value;

                              if (value == Security.public) {
                                _isPrivate = false;
                              }
                            });
                          },
                        )),
                  ),
                  Container(
                    child: ListTile(
                        subtitle: Text("For you and your friends",
                            style: TextStyle(
                              color: Color(0xff777777),
                            )),
                        horizontalTitleGap: 1,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Private",
                            style: TextStyle(fontSize: 14)),
                        leading: Radio<Security>(
                          fillColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                          value: Security.private,
                          groupValue: _security,
                          onChanged: (Security? value) {
                            setState(() {
                              _security = value;

                              if (value == Security.private) {
                                _isPrivate = true;
                              }
                            });
                          },
                        )),
                  )
                ],
              ),
            )),
        Form(
          key: formKey,
          child: Container(
            width: 300,
            height: 130,
            child: ListTile(
              subtitle:
                  Text("Allows players to only own and manage a single team",
                      style: TextStyle(
                        color: Color(0xff777777),
                      )),
              horizontalTitleGap: 1,
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text("Single Team", style: TextStyle(fontSize: 14)),
              leading: Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
                value: _isSingleTeam,
                fillColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary),
                onChanged: (value) {
                  setState(() {
                    _isSingleTeam = value!;
                  });
                },
              ),
            ),
          ),
        )
      ];

  List<Text> titles = [
    Text("Name your league"),
    Text("Security"),
    Text("Preferences")
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: _currentForm >= 0
          ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              IconButton(
                  splashRadius: 17,
                  icon: const Icon(
                    Ionicons.arrow_back,
                    size: 22,
                  ),
                  onPressed: () {
                    _currentForm > 0
                        ? setState(() {
                            _currentForm -= 1;
                          })
                        : Navigator.of(context).pop();
                  }),
              titles[_currentForm]
            ])
          : titles[_currentForm],
      content: forms(context, _formKey)[_currentForm],
      actions: [
        TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: Text('Cancel')),
        TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (_currentForm >= 2) {
                  Navigator.of(context).pop();

                  Navigator.of(context).pushNamed(LoadingScreen.id);

                  final result = await LeagueRequests.createLeague(
                      context, _leagueName, _isPrivate, _isSingleTeam);

                  print(result['exception'].statusCode);

                  if (result['exception'].success) {
                    Navigator.of(context).pushReplacementNamed(
                        FranchiseSelect.id,
                        arguments: {'leagueId': result['body']['leagueId']});
                  }
                } else {
                  setState(() {
                    _currentForm += 1;
                  });
                }
              }
            },
            child: Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
