import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui' as ui;

class LocalizationService {
  static Map<String, String>? _localizedStrings;
  static String currentLang = 'en';
  static const List<String> supportedLanguages = ['en', 'tr', 'it', 'de', 'es', 'pt', 'ru'];

  static Future<void> load() async {
    String deviceLocale = 'en';

    try {

      deviceLocale = ui.PlatformDispatcher.instance.locale.languageCode;
    } catch (e) {
      deviceLocale = 'en';
    }


    currentLang = supportedLanguages.contains(deviceLocale) ? deviceLocale : 'en';

    await _loadJson();
  }

  static Future<void> changeLanguage(String langCode) async {
    if (supportedLanguages.contains(langCode)) {
      currentLang = langCode;
      await _loadJson();
    }
  }

  static Future<void> _loadJson() async {
    try {

      String jsonString = await rootBundle.loadString('assets/lang/$currentLang.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);


      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {

      _localizedStrings = {};
      print("Localization Error: $e");
    }
  }

  static String get(String key) {
    if (_localizedStrings == null) return key;

    return _localizedStrings![key] ?? key;
  }
}