import 'dart:convert';
import 'dart:math';
import 'package:fanplay/loading_page/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:fanplay/home_page/pages/leagues/league_page.dart';
import 'package:fanplay/home_page/pages/leagues/player_auction/player_auction.dart';
import 'package:fanplay/components/league_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fanplay/components/franchise.dart';
import 'package:fanplay/components/league.dart';
import 'package:fanplay/components/http_requests.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'franchise_container.dart';

class FranchiseSelect extends StatefulWidget {
  static const String id = 'FranchiseSelect';

  String leagueId;

  FranchiseSelect({Key? key, required this.leagueId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FranchiseSelectState();
  }
}

class _FranchiseSelectState extends State<FranchiseSelect> {
  var _franchises;
  var _isTeamsLoading = true;

  int _selectedFranchiseIndex = 10;

  late FixedExtentScrollController _wheelController;

  @override
  void initState() {
    loadFranchises();

    _wheelController = FixedExtentScrollController(initialItem: 0);

    super.initState();
  }

  void loadFranchises() async {
    final result = await TeamRequests.getFranchises();

    if (result['exception'].success) {
      _franchises = result['body'] as List<Franchise>;
      _franchises.sort(((Franchise a, Franchise b) =>
          a.franchiseName.compareTo(b.franchiseName)));
    }

    setState(() {
      _isTeamsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Select a franchise"),
          leading: IconButton(
            splashRadius: 17,
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 21,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: !_isTeamsLoading
            ? Container(
                margin: EdgeInsets.only(bottom: 20),
                alignment: Alignment.topCenter,
                child: RotatedBox(
                  quarterTurns: -1,
                  child: ListWheelScrollView.useDelegate(
                    perspective: 0.0001,
                    diameterRatio: 10,
                    clipBehavior: Clip.none,
                    itemExtent: 300,
                    controller: _wheelController,
                    physics: FixedExtentScrollPhysics(),
                    renderChildrenOutsideViewport: true,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedFranchiseIndex = index;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: _franchises.length,
                      builder: (context, i) {
                        return RotatedBox(
                            quarterTurns: 1,
                            child: FranchiseContainer(
                              franchise: _franchises.elementAt(i),
                              franchiseIndex: i,
                              wheelController: _wheelController,
                            ));
                      },
                    ),
                  ),
                ))
            : Center(child: CircularProgressIndicator()),
        floatingActionButton: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 40,
                height: 40,
              ),
              Container(
                width: 140,
                height: 40,
                child: FloatingActionButton(
                  heroTag: 'floating-btn-2',
                  onPressed: () async {
                    Navigator.of(context)
                        .pushReplacementNamed(LoadingScreen.id);

                    final result = await TeamRequests.createTeam(
                        _franchises[_wheelController.selectedItem].id,
                        widget.leagueId);

                    if (result['exception'].success) {
                      Navigator.pushReplacementNamed(context, LeaguePage.id,
                          arguments: {
                            'id': widget.leagueId,
                          });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Next",
                        style: TextStyle(letterSpacing: 0),
                      ),
                      SizedBox(width: 30),
                      Icon(
                        Icons.arrow_right_alt_rounded,
                        size: 40,
                      )
                    ],
                  ),
                  elevation: 2,
                  highlightElevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  heroTag: 'floating-btn-3',
                  onPressed: () {
                    _wheelController.animateToItem(Random().nextInt(31),
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.easeInOut);
                  },
                  child: Icon(
                    Icons.refresh_rounded,
                    size: 30,
                  ),
                  elevation: 2,
                  highlightElevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
