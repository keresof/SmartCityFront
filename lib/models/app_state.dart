import 'package:flutter/foundation.dart';

class AppState with ChangeNotifier {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _language = 'English';
  bool _isLoggedIn = false;

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  String get language => _language;
  bool get isLoggedIn => _isLoggedIn;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}