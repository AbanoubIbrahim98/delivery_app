import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:instamarket/src/requests/languagesRequest.dart';
import 'package:instamarket/src/models/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale appLocale = Locale('en');
  String languageCode;
  List<Language> languages;

  AppLanguage() {
    fetchLocale();
  }

  Locale get appLocal => appLocale ?? Locale("en");
  fetchLocale() async {
    if (languageCode == null) {
      List langs = await languageRequest();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString("languages", json.encode(langs));
      if (langs.length > 0)
        await prefs.setString("languages_code", langs[0]['short_name']);
      languages = [];
      for (int i = 0; i < langs.length; i++) {
        languages.add(Language(
          id: langs[i]['id'],
          name: langs[i]['name'],
          shortName: langs[i]['short_name'],
        ));
      }
      languageCode = langs[0]['short_name'];
      appLocale = Locale(langs[0]['short_name']);
      return Null;
    }

    appLocale = Locale(languageCode);
    return Null;
  }

  void changeLanguage(Locale lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (appLocale == lang) {
      return;
    } else {
      appLocale = lang;
      languageCode = lang.languageCode;

      await prefs.setString("language_code", lang.languageCode);
    }

    notifyListeners();
  }
}
