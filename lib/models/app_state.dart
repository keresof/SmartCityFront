import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState with ChangeNotifier {
  late SharedPreferences _prefs;
  static const String _darkModeKey = 'isDarkMode';
  static const String _notificationsKey = 'notificationsEnabled';
  static const String _languageKey = 'language';
  static const String _isLoggedInKey = 'isLoggedIn';

  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _language = 'tr';
  bool _isLoggedIn = false;

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  String get language => _language;
  bool get isLoggedIn => _isLoggedIn;

  AppState() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    // Load dark mode
    if (_prefs.containsKey(_darkModeKey)) {
      _isDarkMode = _prefs.getBool(_darkModeKey) ?? false;
    } else {
      _isDarkMode = await _getDeviceBrightness() == Brightness.dark;
    }

    // Load notifications setting
    _notificationsEnabled = _prefs.getBool(_notificationsKey) ?? true;

    // Load language
    if (_prefs.containsKey(_languageKey)) {
      _language = _prefs.getString(_languageKey) ?? 'tr';
    } else {
      _language = await _getDeviceLocale();
    }

    // Load login state
    _isLoggedIn = _prefs.getBool(_isLoggedInKey) ?? false;

    notifyListeners();
  }

  Future<Brightness> _getDeviceBrightness() async {
    try {
      var brightness = await PlatformDispatcher.instance.platformBrightness;
      return brightness;
    } catch (e) {
      print('Error getting device brightness: $e');
      return Brightness.light;
    }
  }

  Future<String> _getDeviceLocale() async {
    try {
      final locale = PlatformDispatcher.instance.locale;
      return locale.languageCode;
    } catch (e) {
      print('Error getting device locale: $e');
      return 'tr';
    }
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _prefs.setBool(_darkModeKey, _isDarkMode);
    notifyListeners();
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    _prefs.setBool(_notificationsKey, _notificationsEnabled);
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    _prefs.setString(_languageKey, _language);
    notifyListeners();
  }

  void login() {
    _isLoggedIn = true;
    _prefs.setBool(_isLoggedInKey, _isLoggedIn);
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _prefs.setBool(_isLoggedInKey, _isLoggedIn);
    notifyListeners();
  }
}
