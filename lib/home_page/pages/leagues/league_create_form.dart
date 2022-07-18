import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fanplay/home_page/home.dart';
import 'package:fanplay/components/franchise.dart';
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

  var leagueName;

  String dropdownValue = 'Public';
  bool isPrivate = false;

  Security? _security = Security.public;
  bool _isSingleTeam = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          splashRadius: 17,
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 21,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Create League"),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                child: TextFormField(
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
                    leagueName = value;
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20, right: 20, left: 20),
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
                                  Theme.of(context).colorScheme.secondary),
                              value: Security.public,
                              groupValue: _security,
                              onChanged: (Security? value) {
                                setState(() {
                                  _security = value;

                                  if (value == Security.public) {
                                    isPrivate = false;
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
                                  Theme.of(context).colorScheme.secondary),
                              value: Security.private,
                              groupValue: _security,
                              onChanged: (Security? value) {
                                setState(() {
                                  _security = value;

                                  if (value == Security.private) {
                                    isPrivate = true;
                                  }
                                });
                              },
                            )),
                      )
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        value: _isSingleTeam,
                        fillColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.secondary),
                        onChanged: (value) {
                          setState(() {
                            _isSingleTeam = value!;
                          });
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 1),
                            child: Text(
                              "Single team",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 1),
                            child: Text(
                                "Allows players to only own and manage a single team",
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xff777777))),
                          ),
                        ],
                      )
                    ],
                  )),
            ],
          )),
      floatingActionButton: Container(
        height: 40,
        width: 250,
        //margin: EdgeInsets.only(top: 50, right: 30, left: 30),
        child: FloatingActionButton(
          heroTag: 'floating-btn-2',
          child: Text(
            "Create New League",
            style: TextStyle(letterSpacing: 0),
          ),
          elevation: 2,
          highlightElevation: 4,
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await LeagueRequests.createLeague(
                  leagueName, isPrivate, _isSingleTeam);

              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.id, (route) => false);
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
