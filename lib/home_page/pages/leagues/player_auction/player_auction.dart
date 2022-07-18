import 'package:fanplay/components/franchise.dart';
import 'package:fanplay/components/nba_player.dart';
import 'package:flutter/material.dart';
import 'package:fanplay/components/http_requests.dart';
import '../../../../components/svg_provider.dart' as flutter_svg_provider;

import '../../../../components/tokens.dart';

class PlayerAuction extends StatefulWidget {
  static const id = 'PlayerAuction';

  @override
  State<StatefulWidget> createState() {
    return _PlayerAuctionState();
  }
}

class _PlayerAuctionState extends State<PlayerAuction> {
  int _curFranchiseIndex = 0;
  bool _isFranchisesLoading = true;
  bool _isPlayersLoading = true;
  bool _isTokenLoading = true;

  var accessToken;

  List<Franchise> _franchises = [];
  List<NbaPlayer> _players = [];

  @override
  void initState() {
    loadFranchises();
    getToken();

    super.initState();
  }

  void getToken() async {
    accessToken = await Tokens.getToken('access_token');

    setState(() {
      _isTokenLoading = false;
    });
  }

  void loadFranchises() async {
    final result = await TeamRequests.getFranchises();

    if (result['exception'].success) {
      _franchises = result['body'] as List<Franchise>;
      _franchises.sort((Franchise a, Franchise b) =>
          a.franchiseName.compareTo(b.franchiseName));
    }

    loadPlayers(_franchises[_curFranchiseIndex].rId);

    setState(() {
      _isFranchisesLoading = false;
    });
  }

  void loadPlayers(String franchiseRId) async {
    setState(() {
      _isPlayersLoading = true;
    });

    final result = await TeamRequests.getPlayersByFranchise(franchiseRId);

    if (result['exception'].success) {
      _players = result['body'] as List<NbaPlayer>;
      _players.sort((NbaPlayer a, NbaPlayer b) =>
          a.currentPosition!.compareTo(b.currentPosition!));
    }

    setState(() {
      _isPlayersLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_isFranchisesLoading
        ? Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                primary: false,
                title: Container(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _curFranchiseIndex -= 1;

                            if (_curFranchiseIndex < 0) {
                              _curFranchiseIndex = _franchises.length - 1;
                            }
                          });

                          loadPlayers(_franchises[_curFranchiseIndex].rId);
                        },
                        icon: Icon(
                          Icons.arrow_left_rounded,
                          size: 30,
                        ),
                        splashRadius: 20,
                      ),
                      Text(
                        '${_franchises[_curFranchiseIndex].cityName} ${_franchises[_curFranchiseIndex].franchiseName}',
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _curFranchiseIndex += 1;

                            if (_curFranchiseIndex > _franchises.length - 1) {
                              _curFranchiseIndex = 0;
                            }
                          });

                          loadPlayers(_franchises[_curFranchiseIndex].rId);
                        },
                        icon: Icon(
                          Icons.arrow_right_rounded,
                          size: 30,
                        ),
                        splashRadius: 20,
                      )
                    ],
                  ),
                )),
            body: Container(
              /*decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        _franchises[_curFranchiseIndex].colorPrimary,
                        _franchises[_curFranchiseIndex].colorSecondary,
                      ]),
                  image: !_isTokenLoading
                      ? DecorationImage(
                          /*colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.srcATop),*/
                          //colorFilter: ColorFilter.srgbToLinearGamma(),
                          isAntiAlias: true,
                          fit: BoxFit.none,
                          opacity: 0.1,
                          scale: 0.5,
                          image: flutter_svg_provider.Svg(
                              'http://10.0.2.2:${HttpRequests.PORT}/public/logos/${(_franchises[_curFranchiseIndex].franchiseName).toLowerCase()}/logo.svg',
                              source: flutter_svg_provider.SvgSource.network,
                              headers: {
                                "Authorization": "Bearer $accessToken"
                              }),
                        )
                      : null,
                  boxShadow: const [
                    BoxShadow(
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                        color: Color(0xffD5D5D5))
                  ]),*/
              child: ListTileTheme(
                style: ListTileStyle.list,
                child: !_isPlayersLoading
                    ? ListView(
                        children: _players
                            .map<ListTile>((NbaPlayer player) => ListTile(
                                  title: Text(
                                      '${player.firstName!} ${player.lastName!}'),
                                  subtitle: Text(player.currentPosition!),
                                  trailing: Text('\$100'),
                                ))
                            .toList())
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ))
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
