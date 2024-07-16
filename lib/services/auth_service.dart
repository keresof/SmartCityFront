import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<void> signInWithGoogle() async {
    // Implement Google sign-in logic
  }

  Future<void> signInWithFacebook() async {
    // Implement Facebook sign-in logic
  }

  Future<void> signInWithInstagram() async {
    // Implement Instagram sign-in logic
  }

  Future<void> signInWithEmail(String email, String password) async {
    final response = await _dio.post(
      'https://your-backend-url.com/api/auth/login',
      data: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.data['token']);
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    await _dio.post(
      'https://your-backend-url.com/api/auth/register',
      data: {'email': email, 'password': password},
    );
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
