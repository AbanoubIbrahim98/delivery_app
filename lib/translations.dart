import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:instamarket/src/requests/languageRequest.dart';

class Translations {
  final Locale locale;

  Translations(this.locale);

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  static const LocalizationsDelegate<Translations> delegate =
      TranslationsDelegate();

  Map<String, String> localizedStrings;

  Future<bool> load() async {
    String jsonString = await languageRequestByCode(locale.languageCode);
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String text(String key) {
    return localizedStrings[key] ?? "";
  }
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh', 'fr', 'it', 'ru', 'es'].contains(locale.languageCode);
  }

  @override
  Future<Translations> load(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') != null)
      locale = Locale(prefs.getString('language_code'));

    Translations localizations = new Translations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(TranslationsDelegate old) => true;
}
