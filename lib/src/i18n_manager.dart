import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'i18n_config.dart';

class I18nManager {
  I18nManager._internal();

  // Singleton pattern
  static final I18nManager instance = I18nManager._internal();

  // Current locale
  var _currentLocale = const Locale('en');
  Locale get currentLocale => _currentLocale;

  // Map to store translations
  Map<String, dynamic> _translations = {};
  I18nConfig? _config;

  // Supported locales
  I18nConfig get config => _config!;
  List<Locale> get supportedLocales => _config?.locales ?? [const Locale('en')];

  SharedPreferences? _prefs;

  Future<void> initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> savePrefs(String language) async {
    await initPrefs();
    return await _prefs!.setString('locale', language);
  }

  Future<String?> getPrefs() async {
    await initPrefs();
    return _prefs!.getString('locale');
  }

  // Get text direction based on language
  TextDirection get textDirection {
    // RTL languages
    const rtlLanguages = ['ar', 'he', 'fa', 'ur', 'yi', 'ku', 'ps', 'sd'];
    return rtlLanguages.contains(_currentLocale.languageCode)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  Future<void> init({Locale? initialLocale}) async {
    // Load configuration first
    await _loadConfig();

    if (initialLocale != null) {
      _currentLocale = initialLocale;
    } else {
      final savedLocale = await getPrefs();
      if (savedLocale != null && _isLocaleSupported(Locale(savedLocale))) {
        _currentLocale = Locale(savedLocale);
      } else {
        // Fallback to default locale
        _currentLocale = _config!.defaultLocaleObj;
      }
    }
    await loadLocalTranslations();
  }

  // Load translations from local JSON file
  Future<void> loadLocalTranslations() async {
    try {
      final path = 'assets/i18n/${_currentLocale.languageCode}.json';
      final jsonString = await rootBundle.loadString(path);
      _translations = json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      // Fallback to the configured fallback language
      try {
        final fallbackCode = _config?.fallbackLocale ?? 'en';
        final fallbackPath = 'assets/i18n/$fallbackCode.json';
        final fallbackJsonString = await rootBundle.loadString(fallbackPath);
        _translations = json.decode(fallbackJsonString) as Map<String, dynamic>;
      } catch (e) {
        _translations = {};
      }
    }
  }

  // Load configuration
  Future<void> _loadConfig() async {
    try {
      const configPath = 'assets/i18n/config.json';
      final configString = await rootBundle.loadString(configPath);
      final configJson = json.decode(configString) as Map<String, dynamic>;
      _config = I18nConfig.fromJson(configJson);
    } catch (e) {
      // Fallback configuration
      _config = const I18nConfig(
        supportedLocales: ['en'],
        defaultLocale: 'en',
        fallbackLocale: 'en',
      );
    }
  }

  // Is the given language supported?
  bool _isLocaleSupported(Locale locale) {
    return _config?.supportedLocales.contains(locale.languageCode) ?? false;
  }

  // Change locale and reload translations
  Future<void> changeLocale(Locale newLocale) async {
    if (!_isLocaleSupported(newLocale)) return;

    _currentLocale = newLocale;
    await savePrefs(newLocale.languageCode);
    await loadLocalTranslations();
  }

  // Get translation by key
  String translate(String key, {Map<String, dynamic>? args}) {
    // Split the key by dots to support nested objects
    final keys = key.split('.');
    dynamic value = _translations;

    for (final k in keys) {
      if (value is! Map<String, dynamic> || !value.containsKey(k)) {
        return key;
      }
      value = value[k];
    }

    if (value is! String) {
      return key;
    }

    // Replace args in the translation
    var translation = value;
    if (args != null) {
      args.forEach((argKey, argValue) {
        translation = translation.replaceAll('{$argKey}', argValue.toString());
      });
    }
    return translation;
  }
}
