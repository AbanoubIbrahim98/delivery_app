import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        brightness: Brightness.light,
      ),
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.transparent),
      fontFamily: 'Lato',
      backgroundColor: Color.fromRGBO(241, 242, 246, 1),
      buttonColor: Colors.white,
      primaryColor: Colors.black,
      unselectedWidgetColor: Colors.black,
      brightness: Brightness.dark);
}
