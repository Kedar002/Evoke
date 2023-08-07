import 'package:evoke/constants/constants.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: lightScaffoldBackgroundColor,
  appBarTheme: AppBarTheme(
    color: lightCardColor,
  ),
);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkScaffoldBackgroundColor,
    appBarTheme: AppBarTheme(
      color: darkCardColor,
    ));




//  ThemeData(
            // scaffoldBackgroundColor: lightScaffoldBackgroundColor,
            // appBarTheme: AppBarTheme(
            //   color: lightCardColor,
//             )),
        // darkTheme: ThemeData(
            // scaffoldBackgroundColor: darkScaffoldBackgroundColor,
            // appBarTheme: AppBarTheme(
            //   color: darkCardColor,
            // )),
        // themeMode: ThemeMode.system,