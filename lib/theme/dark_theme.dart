import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
      ),
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.transparent),
      fontFamily: 'Lato',
      backgroundColor: Color(0xFF212121),
      buttonColor: Color(0xFF212121),
      primaryColor: Colors.white,
      unselectedWidgetColor: Color(0xFF212121),
      brightness: Brightness.light);
}
