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
    _user = token != null ? User(id: '', email: '') : null; // You might want to fetch user details here
    notifyListeners();
  }

  Future<bool> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Placeholder methods for other social logins
  Future<bool> signInWithFacebook() async {
    // Placeholder implementation
    print('Facebook login not implemented');
    return false;
  }

  Future<bool> signInWithInstagram() async {
    // Placeholder implementation
    print('Instagram login not implemented');
    return false;
  }
}