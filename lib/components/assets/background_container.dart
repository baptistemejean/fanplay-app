import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primary,
          ])),
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Theme.of(context).colorScheme.tertiaryContainer,
            Theme.of(context).colorScheme.primary,
          ])),
    );
  }
}
