import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNotifier with ChangeNotifier {
  int mode = 0;

  SettingsNotifier() {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mode = prefs.getInt('mode') ?? 0;
  }

  void setData(int mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("mode", mode);
  }

  void setMode(int modeData) {
    mode = modeData;
    setData(modeData);

    notifyListeners();
  }
}
