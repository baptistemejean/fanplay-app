import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  static const String id = 'LoadingScreen';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
