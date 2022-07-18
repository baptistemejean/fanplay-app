import 'package:flutter/material.dart';

ThemeData LightTheme() {
  const primary = Color(0xffFF331F);
  const primaryVariant = Color(0xff552583);
  const secondary = Color(0xffBF2717);
  const secondaryVariant = Color(0xffEC6028);
  //const tertiary = Color(0xffc7e7ff);
  const tertiary = Color(0xffD4D4D4);
  const tertiaryContainer = Color(0xffF9A01B);

  return ThemeData(
      colorScheme: const ColorScheme(
          primary: primary,
          primaryContainer: primaryVariant,
          secondary: secondary,
          secondaryContainer: secondaryVariant,
          tertiary: tertiary,
          tertiaryContainer: tertiaryContainer,
          surface: Colors.grey,
          background: Color(0xfff8f8f8), //Color(0xff202020),
          error: primaryVariant,
          onSurface: Colors.black,
          onBackground: Color(0xfff2f2f2),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onError: Colors.white,
          brightness: Brightness.light),
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
        elevation: 4,
        primary: primary,
        onPrimary: Colors.white,
        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadowColor: Colors.black.withOpacity(0.5),
        minimumSize: Size(130, 48),
      )),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        elevation: 0,
      )));
}
