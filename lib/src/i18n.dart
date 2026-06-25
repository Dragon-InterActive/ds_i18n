import 'dart:async';
import 'package:flutter/widgets.dart' show Locale;

import 'i18n_manager.dart';

/// Public entry point for translations.
///
/// The package is named `ds_i18n`, but this is the class you call:
///
/// ```dart
/// Text(I18n.t('title'));
/// ```
class I18n {
  I18n._();

  /// Supported locales, loaded dynamically from `config.json`.
  static List<Locale> get supportedLocales =>
      I18nManager.instance.supportedLocales;

  /// Translates [key], optionally substituting [args] (e.g. `{count}`).
  static String translate(String key, {Map<String, dynamic>? args}) {
    return I18nManager.instance.translate(key, args: args);
  }

  /// Shorthand alias for [translate].
  static String t(String key, {Map<String, dynamic>? args}) {
    return I18nManager.instance.translate(key, args: args);
  }
}

/// Convenience helpers for switching locales at runtime.
extension LocaleChange on I18nManager {
  /// Switches to the first supported locale (usually the default).
  void changeToFirstLocale() => unawaited(changeLocale(supportedLocales.first));

  /// Cycles to the next supported locale.
  void changeToNextLocale() {
    final currentIndex = supportedLocales.indexWhere(
      (locale) => locale.languageCode == currentLocale.languageCode,
    );
    final nextIndex = (currentIndex + 1) % supportedLocales.length;
    unawaited(changeLocale(supportedLocales[nextIndex]));
  }

  /// Switches to a specific [languageCode] if it is supported,
  /// otherwise falls back to the first supported locale.
  void changeToLocale(String languageCode) {
    final locale = supportedLocales.firstWhere(
      (l) => l.languageCode == languageCode,
      orElse: () => supportedLocales.first,
    );
    unawaited(changeLocale(locale));
  }
}
