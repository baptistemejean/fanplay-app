import 'package:flutter/material.dart';

ThemeData DarkTheme() {
  const primary = Color(0xffFF331F);
  const secondary = Color(0xff1B4965);
  const tertiary = Color(0xffc7e7ff);

  return ThemeData(
      colorScheme: const ColorScheme(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        surface: Color(0xff7B7B7B),
        background: Color(0xff191919),
        error: Color(0xffed2d2d),
        onSurface: Colors.white,
        onBackground: Color(0xff777777),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: primary),
          titleTextStyle:
              TextStyle(color: primary, fontFamily: 'Kanit', fontSize: 20)),
      fontFamily: 'Kanit',
      textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 56, fontWeight: FontWeight.w700),
          bodyText1: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          bodyText2: TextStyle(fontSize: 20, color: primary)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
        highlightElevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: primary,
            onPrimary: Colors.white,
            splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            minimumSize: Size(130, 40)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        elevation: 0,
      )));
}
