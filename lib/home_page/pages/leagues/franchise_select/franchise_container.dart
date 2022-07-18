import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fanplay/components/http_requests.dart';
import 'package:fanplay/components/league_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fanplay/components/franchise.dart';
import 'package:fanplay/components/league.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../../../../components/svg_provider.dart' as flutter_svg_provider;

import '../../../../components/tokens.dart';

class FranchiseContainer extends StatefulWidget {
  Franchise franchise;
  int franchiseIndex;
  FixedExtentScrollController wheelController;

  FranchiseContainer(
      {required this.franchise,
      required this.franchiseIndex,
      required this.wheelController});

  @override
  State<StatefulWidget> createState() {
    return _FranchiseContainerState();
  }
}

class _FranchiseContainerState extends State<FranchiseContainer> {
  bool _isTokenLoading = true;
  var accessToken;

  @override
  void initState() {
    getToken();

    super.initState();
  }

  void getToken() async {
    accessToken = await Tokens.getToken('access_token');

    setState(() {
      _isTokenLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      clipBehavior: Clip.hardEdge,
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 5, top: 0, right: 5, left: 5),
      padding: EdgeInsets.only(left: 40, right: 40),
      height: widget.wheelController.selectedItem == widget.franchiseIndex
          ? 400
          : 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(255, 0, 0, 0),
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                widget.franchise.colorPrimary,
                widget.franchise.colorSecondary,
              ]),
          image: !_isTokenLoading
              ? DecorationImage(
                  /*colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.srcATop),*/
                  //colorFilter: ColorFilter.srgbToLinearGamma(),
                  isAntiAlias: true,
                  fit: BoxFit.none,
                  opacity: 0.1,
                  scale: 0.3,
                  image: flutter_svg_provider.Svg(
                      'http://10.0.2.2:${HttpRequests.PORT}/public/logos/${(widget.franchise.franchiseName).toLowerCase()}/logo.svg',
                      source: flutter_svg_provider.SvgSource.network,
                      headers: {"Authorization": "Bearer $accessToken"}),
                )
              : null,
          boxShadow: const [
            BoxShadow(
                spreadRadius: 0,
                blurRadius: 3,
                offset: Offset(0, 2),
                color: Color(0xffD5D5D5))
          ]),
      child: ListView(children: [
        Container(
          margin: EdgeInsets.only(top: 100),
          //shrinkWrap: true,
          child:
              /*!isTokenLoading
                ? SvgPicture.network(
                    'http://10.0.2.2:${HttpRequests.PORT}/public/logos/${(widget.franchise.franchiseName).toLowerCase()}/logo.svg',
                    headers: {"Authorization": "Bearer $accessToken"},
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.none,
                    //allowDrawingOutsideViewBox: true,
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    colorBlendMode: BlendMode.srcATop,
                    color: Colors.black.withOpacity(0.6),
                  )
                : Center(child: CircularProgressIndicator()),
                !isTokenLoading
                    ? Image.network(
                        'http://10.0.2.2:${HttpRequests.PORT}/public/logos/${(widget.franchise.franchiseName).toLowerCase()}/text.png',
                        headers: {"Authorization": "Bearer $accessToken"},
                        colorBlendMode: BlendMode.srcATop,
                        color: Colors.white.withOpacity(1),
                        scale: 4,
                      )
                    : null*/
              Text(
            '${widget.franchise.cityName}\n${widget.franchise.franchiseName}'
                .toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.background,
                fontSize: 29,
                fontWeight: FontWeight.bold,
                height: 1,
                textBaseline: TextBaseline.alphabetic),
          ),
        ),
        AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.only(top: 30),
            transform: Matrix4.translationValues(
                0,
                widget.wheelController.selectedItem == widget.franchiseIndex
                    ? 0
                    : 200,
                0),
            clipBehavior: Clip.none,
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                  style: TextStyle(
                      fontFamily: 'Kanit',
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 16),
                  children: const <TextSpan>[
                    TextSpan(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      text: '• The Mecca : ',
                    ),
                    TextSpan(
                      style: TextStyle(),
                      text: 'enhanced sales and fan involvement\n\n',
                    ),
                    TextSpan(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      text: '• Rebuilding : ',
                    ),
                    TextSpan(
                      style: TextStyle(),
                      text: 'reduced young player\'s salary (22 and less)',
                    )
                  ]),
            ))
      ]),
    );
  }
}
