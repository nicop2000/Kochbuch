import 'package:flutter/material.dart';

ColorScheme lightBase = const ColorScheme(
    primary: Color(0x00000000),
    //AppBar
    primaryVariant: Color(0x00000000),
    secondary: Color(0x00000000),
    //Buttonfarbe
    secondaryVariant: Color(0x00000000),
    surface: Color(0xff000000),
    background: Color(0xfff9f9f9),
    error: Color(0xffc30000),
    //error
    onPrimary: Color(0xff000000),
    onSecondary: Color(0xff000000),
    onSurface: Color(0xffffffff),
    onBackground: Color(0xff000000),
    onError: Color(0xffffffff),
    brightness: Brightness.light);

ColorScheme darkBase = const ColorScheme(
    primary: Color(0x00000000),
    primaryVariant: Color(0x00000000),
    secondary: Color(0x00000000),
    secondaryVariant: Color(0x00000000),
    surface: Color(0xffffffff),
    background: Color(0xff303030),
    error: Color(0xff820000),
    onPrimary: Color(0xffffffff),
    onSecondary: Color(0xffffffff),
    onSurface: Color(0xff000000),
    onBackground: Color(0xffffffff),
    onError: Color(0xffffffff),
    brightness: Brightness.dark);



ColorScheme _baseScheme(Brightness brightness) {
  if (brightness == Brightness.light) {
    return lightBase;
  } else {
    return darkBase;
  }
}

ColorScheme createColorScheme(
    {required Brightness brightness,
    required Color primary,
    required Color primaryVariant,
    required Color secondary,
    required Color secondaryVariant}) {
  return _baseScheme(brightness).copyWith(
      primary: primary,
      primaryVariant: primaryVariant,
      secondary: secondary,
      secondaryVariant: secondaryVariant);
}

// ColorScheme c1Dark = ColorScheme(
//     background: Colors.red,
//     onBackground: Colors.white,
//     primary: Colors.amber,
//     //darkmode schrift auf appbar und buttons
//     primaryVariant: Colors.black38,
//     onPrimary: Colors.green,
//     secondary: Colors.blue,
//     secondaryVariant: Colors.brown,
//     onSecondary: Colors.limeAccent,
//     error: Colors.purple,
//     onError: Colors.pink,
//     surface: Colors.teal,
//     //darkmode appbar
//     onSurface: Colors.orange,
//     brightness: Brightness.dark);

ColorScheme c2Light = ColorScheme(
    primary: Color(0xffb7fff9),
    primaryVariant: Color(0xffdcfffb),
    secondary: Color(0xffb388ac),
    secondaryVariant: Color(0xffe5b8de),
    surface: Color(0xff),
    background: Color(0xff),
    error: Color(0xff),
    onPrimary: Color(0xff),
    onSecondary: Color(0xff),
    onSurface: Color(0xff),
    onBackground: Color(0xff),
    onError: Color(0xff),
    brightness: Brightness.light);

ColorScheme c2Dark = ColorScheme(
    primary: Color(0xff4fba95),
    primaryVariant: Color(0xffdcfffb),
    secondary: Color(0xffb388ac),
    secondaryVariant: Color(0xffe5b8de),
    surface: Color(0xff),
    background: Color(0xff),
    error: Color(0xff),
    onPrimary: Color(0xff),
    onSecondary: Color(0xff),
    onSurface: Color(0xff),
    onBackground: Color(0xff),
    onError: Color(0xff),
    brightness: Brightness.dark);

TextTheme cText(ColorScheme colorScheme) => TextTheme(
    bodyText1: TextStyle(fontSize: 14, color: colorScheme.onPrimary, fontWeight: FontWeight.normal),
    bodyText2: TextStyle(fontSize: 20, color: colorScheme.onPrimary, fontWeight: FontWeight.normal), //Picker
    button: TextStyle(
      color: colorScheme.secondary,
      fontSize: 14,
    ),
    headline1: TextStyle(
        fontSize: 22,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal,
        color: colorScheme.onPrimary),
    headline2: TextStyle(
        fontSize: 20,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.bold,
        color: colorScheme.onPrimary),
    headline3: TextStyle(
        fontSize: 18,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w500,
        color: colorScheme.onPrimary),
    headline4: TextStyle(
        fontSize: 16,
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.bold,
        color: colorScheme.onPrimary) //Ingredients, Instructions, ...
    );


ColorScheme c1L = createColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xff83edc6),
    primaryVariant: const Color(0x604fba95),
    secondary: const Color(0xffb388ac),
    secondaryVariant: const Color(0xffe5b8de));
ColorScheme c1D = createColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xff164f30),
    primaryVariant: const Color(0x60447c59),
    secondary: const Color(0xffaa22cc),
    secondaryVariant: const Color(0xff6b4b66));
