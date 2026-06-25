// Scaffolding command for ds_i18n.
//
// Run once in your Flutter project root after adding the dependency:
//
//   dart run ds_i18n:init
//
// Creates assets/i18n/{config.json, en.json, de.json} without overwriting
// existing files (use --force to overwrite), and reminds you to register the
// assets folder in your pubspec.yaml.
//
// Pure dart:io — no Flutter import, so it runs via `dart run`.

import 'dart:io';

const _configJson = '''
{
  "supportedLocales": ["en", "de"],
  "defaultLocale": "en",
  "fallbackLocale": "en"
}
''';

const _enJson = '''
{
  "appTitle": "My App",
  "greeting": "Hello, {name}!",
  "menu": {
    "settings": "Settings"
  }
}
''';

const _deJson = '''
{
  "appTitle": "Meine App",
  "greeting": "Hallo, {name}!",
  "menu": {
    "settings": "Einstellungen"
  }
}
''';

void main(List<String> args) {
  final force = args.contains('--force') || args.contains('-f');

  stdout.writeln('ds_i18n: scaffolding assets/i18n/ ...\n');

  final dir = Directory('assets/i18n');
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
    stdout.writeln('  created  assets/i18n/');
  }

  final files = <String, String>{
    'assets/i18n/config.json': _configJson.trim(),
    'assets/i18n/en.json': _enJson.trim(),
    'assets/i18n/de.json': _deJson.trim(),
  };

  var created = 0;
  var skipped = 0;
  files.forEach((path, content) {
    final file = File(path);
    final existedBefore = file.existsSync();
    if (existedBefore && !force) {
      stdout.writeln('  skipped  $path (already exists)');
      skipped++;
    } else {
      file.writeAsStringSync('$content\n');
      stdout.writeln('  ${existedBefore ? "wrote  " : "created"}  $path');
      created++;
    }
  });

  _checkPubspec();

  stdout.writeln('\nDone. $created written, $skipped skipped.');
  if (skipped > 0 && !force) {
    stdout.writeln('Re-run with --force to overwrite existing files.');
  }
}

void _checkPubspec() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    stdout.writeln('\n  ! No pubspec.yaml found in the current directory.');
    stdout.writeln('    Run this command from your Flutter project root.');
    return;
  }

  final content = pubspec.readAsStringSync();
  if (content.contains('assets/i18n')) {
    stdout.writeln('\n  ok  pubspec.yaml already registers assets/i18n/');
    return;
  }

  stdout.writeln('\n  ! Add the assets folder to your pubspec.yaml:\n');
  stdout.writeln('    flutter:');
  stdout.writeln('      assets:');
  stdout.writeln('        - assets/i18n/');
}
