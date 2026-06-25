# ds_i18n_example

A minimal Flutter app demonstrating [`ds_i18n`](../).

It shows:
- initialization in `main()`
- `I18n.t()` for simple lookups
- argument substitution (`{name}`, `{count}` — including a non-String int)
- nested keys via dot notation (`menu.settings`)
- runtime language switching
- text direction (LTR/RTL) via `I18nManager.instance.textDirection`

## Run

```bash
cd example
flutter pub get
flutter run
```

The translation files live in `assets/i18n/` and are registered in this
example's `pubspec.yaml`. In your own project you can generate the same base
files with:

```bash
dart run ds_i18n:init
```
