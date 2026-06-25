## 0.1.0

* **Renamed package** from `i18n` to `ds_i18n`. The import is now
  `package:ds_i18n/ds_i18n.dart`. The public API is unchanged — you still
  call `I18n.t('key')`.
* **BREAKING (config):** the config key `supportedLocals` was renamed to the
  correctly spelled `supportedLocales`. Update your `assets/i18n/config.json`
  accordingly.
* **Restructured** into a single public barrel (`lib/ds_i18n.dart`) with the
  implementation moved under `lib/src/`.
* **Fixed:** config parsing crashed because `fromJson` read the misspelled key
  `fallbacklocale` instead of `fallbackLocale`.
* **Fixed:** `translate()` threw a runtime type error when a non-String
  argument (e.g. an `int` count) was passed via `args`. Values are now
  converted with `toString()`.
* **Fixed:** the configured `fallbackLocale` was ignored — the translation
  fallback was hard-coded to `en.json`. It now uses the configured fallback.
* Raised minimum Flutter constraint to `>=3.35.1`.
* Relicensed from GPL-3.0 to BSD-3-Clause.
* Added `dart run ds_i18n:init` to scaffold `assets/i18n/` base files in a
  consuming project.
* Added a runnable `example/` app.

## 0.0.1

* Initial release: JSON-based localization with runtime locale switching,
  nested keys, argument substitution, RTL detection, and persistence via
  shared_preferences.
