# ds_i18n — JSON-based localization for Flutter

A lightweight localization tool driven entirely by JSON files. No code
generation, no build runner. Drop your translation files into `assets/i18n/`,
call `I18n.t('key')`, and switch languages at runtime.

> **Package name vs. usage:** The package is named `ds_i18n` (so the import is
> `package:ds_i18n/ds_i18n.dart`), but the API you call is the `I18n` class —
> e.g. `I18n.t('title')`. Only the import line differs from the class you use.

## Getting started

Add the dependency, then scaffold the base files with one command:

```bash
dart run ds_i18n:init
```

This creates `assets/i18n/config.json`, `en.json`, and `de.json` in your
project (existing files are never overwritten — pass `--force` to overwrite),
and reminds you to register the assets folder in your `pubspec.yaml`.

> A package cannot create these files automatically on install — Dart has no
> install hooks by design. The `init` command is the one-step equivalent.

If you prefer to set things up by hand, the files are described below.

### `assets/i18n/config.json`

- `supportedLocales`: array of 2-char language codes your app supports
- `defaultLocale`: initial language
- `fallbackLocale`: used when a translation file can't be loaded

```json
{
    "supportedLocales": [
        "en",
        "de"
    ],
    "defaultLocale": "en",
    "fallbackLocale": "en"
}
```

> Note: all config keys are case-sensitive — `supportedLocales`,
> `defaultLocale`, `fallbackLocale`.

### Language files

Use the 2-char language code as the filename, e.g. `en.json`, `de.json`,
`fr.json`.

```json
{
    "title": "My App",
    "error": "Error!",
    "errorWithCounter": "Error! Input must be {count} characters long!"
}
```

### Register the assets

In your app's `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/i18n/
```

## Initialization

Your `main()` needs to be async:

```dart
import 'package:ds_i18n/ds_i18n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await I18nManager.instance.init(initialLocale: systemLocale);
  runApp(const YourApp());
}
```

If you use Riverpod, a notifier for the current locale can look like this:

```dart
class LocalizationNotifier extends StateNotifier<Locale> {
  LocalizationNotifier() : super(const Locale('en')) {
    _init();
  }

  void _init() {
    // Read the current locale from I18nManager
    final currentLocale = I18nManager.instance.currentLocale;
    // Normalize (e.g. en_US -> en)
    state = Locale(currentLocale.languageCode);
  }

  Future<void> changeLocale(Locale newLocale) async {
    if (state.languageCode != newLocale.languageCode) {
      await I18nManager.instance.changeLocale(newLocale);
      state = newLocale;
    }
  }

  List<Locale> get supportedLocales => I18nManager.instance.supportedLocales;
  TextDirection get textDirection => I18nManager.instance.textDirection;
}

final localizationProvider =
    StateNotifierProvider<LocalizationNotifier, Locale>((ref) {
      return LocalizationNotifier();
    });
```

## Usage

Import the package:

```dart
import 'package:ds_i18n/ds_i18n.dart';
```

Then translate with `I18n.translate()` or the shorthand `I18n.t()`:

```dart
// Shorthand
Text(I18n.t('title'));

// Full form
Text(I18n.translate('title'));
```

### Argument substitution

Replace placeholders like `{count}` via `args`:

```dart
const count = 5;
Text(I18n.t('errorWithCounter', args: {'count': count}));
// -> "Error! Input must be 5 characters long!"
```

Non-String values are converted automatically.

### Nested keys

Dotted keys resolve nested JSON objects:

```json
{
    "menu": {
        "file": "File",
        "edit": "Edit"
    }
}
```

```dart
Text(I18n.t('menu.file')); // -> "File"
```

### Language switcher

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/app_providers.dart'; // your Riverpod provider

class LanguageSwitch extends ConsumerWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localizationProvider);
    final localizationNotifier = ref.read(localizationProvider.notifier);
    final normalizedLocale = Locale(currentLocale.languageCode);

    return PopupMenuButton<Locale>(
      padding: EdgeInsets.zero,
      offset: const Offset(0, 40),
      initialValue: normalizedLocale,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        child: Text(
          normalizedLocale.languageCode.toUpperCase(),
          style: const TextStyle(fontSize: 18),
        ),
      ),
      itemBuilder: (context) => const [
        PopupMenuItem(value: Locale('en'), child: Text('English')),
        PopupMenuItem(value: Locale('de'), child: Text('Deutsch')),
      ],
      onSelected: localizationNotifier.changeLocale,
    );
  }
}
```

## Important

- Your language and config files must live in `assets/i18n/` in your project
  root, and the folder must be registered under `flutter: assets:`.
- This package uses `shared_preferences` to persist the selected language.

## AI agent skill

An Agent Skill for use with Claude (Claude Code / claude.ai) is maintained
separately at:

**https://github.com/dragon-interactive/skills/ds_i18n/**

It teaches the assistant how to configure and use `ds_i18n` correctly. It is
not part of this package — install it into your own agent skills directory.

## License

BSD-3-Clause. See [LICENSE](LICENSE). Free to use, fork, and extend —
attribution required, no endorsement implied.
