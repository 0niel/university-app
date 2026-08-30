import 'dart:ui';

enum AppLanguage {
  system,
  ru,
  en;

  Locale? get locale => switch (this) {
    .system => null,
    .ru => const .new('ru'),
    .en => const .new('en'),
  };
}
