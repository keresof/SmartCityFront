import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:smart_city_app/services/auth_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<bool> signIn(String email, String password) async {
    final user = await _authService.signInWithEmail(email, password);
    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signUp(String email, String password) async {
    return await _authService.signUpWithEmail(email, password);
  }

  Future<void> setUser(User user) async {
    _user = user;
    notifyListeners();
  }

  Future<bool> signOut() async {
    final success = await _authService.signOut();
    if (success) {
      _user = null;
      notifyListeners();
    }
    return success;
  }

  Future<void> checkAuthStatus() async {
  final token = await _authService.getToken();
  if (token != null) {
    try {
      // Decode the token to get user information
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = parts[1];
        final normalized = base64Url.normalize(payload);
        final resp = utf8.decode(base64Url.decode(normalized));
        final payloadMap = json.decode(resp);
        
        _user = User(id: payloadMap['sub'], email: payloadMap['email']);
      } else {
        _user = null;
      }
    } catch (e) {
      print('Error decoding token: $e');
      _user = null;
    }
  } else {
    _user = null;
  }
  notifyListeners();
}

  Future<bool> signInWithGoogle() async {
    print("Starting Google Sign-In process");
    final user = await _authService.signInWithGoogle();
    print("Returned user from AuthService: $user");
    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    
    print("Google Sign-In failed: user is null");
    return false;
  }

  Future<bool> signInWithFacebook() async {
    print('Facebook login not implemented');
    return false;
  }

  Future<bool> signInWithInstagram() async {
    print('Instagram login not implemented');
    return false;
  }

  Future<bool> refreshToken() async {
    final success = await _authService.refreshToken();
    if (!success) {
      _user = null;
      notifyListeners();
    }
    return success;
  }
}