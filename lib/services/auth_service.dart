import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';

class AuthService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://4065-85-102-229-52.ngrok-free.app/api';
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200 && response.data['success']) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        await prefs.setString('refreshToken', response.data['refreshToken']);
        return User(id: response.data['sub'], email: email);
      }
      return null;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/register',
        data: {'email': email, 'password': password},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error signing up: $e');
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final refreshToken = prefs.getString('refreshToken');
      
      final response = await _dio.post(
        '$baseUrl/auth/logout',
        data: {'accessToken': token, 'refreshToken': refreshToken},
      );
      
      if (response.statusCode == 200) {
        await prefs.remove('token');
        await prefs.remove('refreshToken');
        await _googleSignIn.signOut();
        return true;
      }
      return false;
    } catch (e) {
      print('Error signing out: $e');
      return false;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');
      
      final response = await _dio.post(
        '$baseUrl/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      
      if (response.statusCode == 200 && response.data['success']) {
        await prefs.setString('token', response.data['token']);
        await prefs.setString('refreshToken', response.data['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final response = await _dio.post(
        '$baseUrl/auth/o/google/cb',
        data: {
          'code': googleAuth.idToken,
          'state': 'google', // You might want to generate and validate a state
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        await prefs.setString('refreshToken', response.data['refreshToken']);
        return User(id: response.data['sub'], email: googleUser.email);
      }
      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }
}