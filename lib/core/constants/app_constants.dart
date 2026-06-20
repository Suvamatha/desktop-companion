/// Central place for all app-wide constants.
/// Why? If you hardcode values everywhere and need to change them,
/// you'd have to hunt through 50 files. Here, you change one line.
class AppConstants {
  // Window
  static const double windowWidth = 380.0;
  static const double windowHeight = 520.0;
  static const double windowMinWidth = 280.0;
  static const double windowMinHeight = 380.0;

  // App info
  static const String appName = 'Desktop Companion';
  static const String appVersion = '1.0.0';

  // Storage keys (Hive box names)
  static const String settingsBox = 'settings';
  static const String streakBox = 'streaks';
  static const String achievementsBox = 'achievements';

  // Character
  static const Duration idleTimeout = Duration(minutes: 5);
  static const Duration sleepTimeout = Duration(minutes: 15);

  // GitHub
  static const String githubApiBase = 'https://api.github.com';
  static const Duration githubRefreshInterval = Duration(minutes: 30);

  // Private constructor — this class should never be instantiated
  AppConstants._();
}
