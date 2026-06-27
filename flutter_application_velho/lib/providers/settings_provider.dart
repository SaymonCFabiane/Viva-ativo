import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettings {
  final double textScale;
  final double volume;
  final bool notifications;
  final bool darkMode;
  final String language;

  const AppSettings({
    this.textScale = 1.1,
    this.volume = 0.8,
    this.notifications = true,
    this.darkMode = false,
    this.language = 'pt',
  });

  AppSettings copyWith({
    double? textScale,
    double? volume,
    bool? notifications,
    bool? darkMode,
    String? language,
  }) {
    return AppSettings(
      textScale: textScale ?? this.textScale,
      volume: volume ?? this.volume,
      notifications: notifications ?? this.notifications,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
    );
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  void updateTextScale(double scale) => state = state.copyWith(textScale: scale);
  void updateVolume(double volume) => state = state.copyWith(volume: volume);
  void toggleNotifications() => state = state.copyWith(notifications: !state.notifications);
  void toggleDarkMode() => state = state.copyWith(darkMode: !state.darkMode);
  void updateLanguage(String lang) => state = state.copyWith(language: lang);
}
