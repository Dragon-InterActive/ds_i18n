import 'package:flutter/material.dart';
import 'package:ds_i18n/ds_i18n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load config + the persisted/default locale and its translations.
  await I18nManager.instance.init();
  runApp(const DemoApp());
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  Future<void> _switchLocale(Locale locale) async {
    await I18nManager.instance.changeLocale(locale);
    if (mounted) setState(() {}); // rebuild so I18n.t() re-resolves
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ds_i18n Demo',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF990000), useMaterial3: true),
      // Honor the current language's text direction (LTR/RTL).
      home: Directionality(
        textDirection: I18nManager.instance.textDirection,
        child: DemoPage(onSwitch: _switchLocale),
      ),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key, required this.onSwitch});

  final ValueChanged<Locale> onSwitch;

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int _taps = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.t('appTitle')),
        actions: [
          PopupMenuButton<Locale>(
            initialValue: Locale(I18nManager.instance.currentLocale.languageCode),
            onSelected: widget.onSwitch,
            itemBuilder: (context) => I18n.supportedLocales
                .map((l) => PopupMenuItem(
                      value: l,
                      child: Text(l.languageCode.toUpperCase()),
                    ))
                .toList(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  I18nManager.instance.currentLocale.languageCode.toUpperCase(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            // Argument substitution: {name}
            Text(
              I18n.t('greeting', args: {'name': 'Nemo'}),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            // Nested key via dot notation.
            Text(I18n.t('menu.settings')),
            // Non-String arg (int) — converted automatically.
            Text(I18n.t('counter', args: {'count': _taps})),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _taps++),
        child: const Icon(Icons.add),
      ),
    );
  }
}
