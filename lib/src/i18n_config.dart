import 'package:flutter/widgets.dart' show Locale;

/// Parsed representation of `assets/i18n/config.json`.
class I18nConfig {
  final List<String> supportedLocales;
  final String defaultLocale;
  final String fallbackLocale;

  const I18nConfig({
    required this.supportedLocales,
    required this.defaultLocale,
    required this.fallbackLocale,
  });

  factory I18nConfig.fromJson(Map<String, dynamic> json) {
    return I18nConfig(
      supportedLocales: List<String>.from(json['supportedLocales']),
      defaultLocale: json['defaultLocale'],
      fallbackLocale: json['fallbackLocale'],
    );
  }

  List<Locale> get locales =>
      supportedLocales.map((code) => Locale(code)).toList();

  Locale get defaultLocaleObj => Locale(defaultLocale);
  Locale get fallbackLocaleObj => Locale(fallbackLocale);
}
