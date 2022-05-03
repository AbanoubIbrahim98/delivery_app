import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instamarket/src/models/User.dart';

class AuthNotifier with ChangeNotifier {
  User user;
  bool isAuthenticated = false;
  bool isGuest = false;

  AuthNotifier() {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isGuest = prefs.getBool('isGuest') ?? false;
    isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

    user = prefs.getString('user') != null
        ? User.fromJson(json.decode(prefs.getString('user')))
        : null;
  }

  void setData(bool isGuest, bool isAuthenticated, User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isGuest", isGuest);
    prefs.setBool("isAuthenticated", isAuthenticated);
    if (user != null)
      prefs.setString("user", json.encode(user.toJson()));
    else
      prefs.remove("user");
  }

  void makeGuest() {
    isGuest = true;

    setData(true, false, null);

    notifyListeners();
  }

  void logIn(User newUser) {
    isGuest = false;
    isAuthenticated = true;
    user = newUser;

    setData(false, true, newUser);

    notifyListeners();
  }

  void logOut() async {
    isGuest = false;
    isAuthenticated = false;
    user = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }
}
