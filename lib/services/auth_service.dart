import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';
import 'google_sign_in_config.dart';

class AuthService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://smartcity.demo.xn--glolu-jua30a.com/api';
  late GoogleSignIn _googleSignIn;

  AuthService() {
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    final clientId = await GoogleSignInConfig.getClientId();
    _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      clientId: clientId,
      serverClientId: clientId, 
    );
  }

  Future<String?> getGoogleAuthUrl() async {
    try {
      final response = await _dio.get('$baseUrl/auth/o/google', options: Options(followRedirects: false));
      if (response.statusCode == 200 || response.statusCode == 302) {
        return response.headers.value('location');
      }
      print('Error getting Google auth URL: ${response.statusCode}');
      return null;
    } on DioException catch (e) {
      print('DioException getting Google auth URL: ${e.message}');
      print('DioException type: ${e.type}');
      print('DioException response: ${e.response}');
      return null;
    } catch (e) {
      print('Error getting Google auth URL: $e');
      return null;
    }
  }

  Future<User?> handleGoogleCallback(String code, String state) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/auth/o/google/cb',
        data: {
          'code': code,
          'state': state,
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        await prefs.setString('refreshToken', response.data['refreshToken']);
        return User(id: response.data['sub'], email: response.data['email']);
      } else {
        print('Server response error: ${response.statusCode} - ${response.data}');
        return null;
      }
    } catch (e) {
      print('Error handling Google callback: $e');
      return null;
    }
  }

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
        final tokenPayload = response.data['token'].split('.')[1];
        final tokenLength = tokenPayload.length;
        late  final padding = '=' * ((4 - (tokenLength % 4))%4).toInt();
        final finalPayload = tokenPayload + padding;
        final decodedPayload = String.fromCharCodes(base64Url.decode(finalPayload ));
        final payload = jsonDecode(decodedPayload);
        final userId = payload['sub'];
        return User(id: userId, email: email);
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
      print("1. Attempting to sign in with Google");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('2. Google Sign-In cancelled by user');
        return null;
      }
      print("3. Google Sign-In successful for email: ${googleUser.email}");

      print("4. Requesting Google authentication");
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print("5. Received Google authentication");

      print("6. Sending request to backend");
      final response = await _dio.post(
        '$baseUrl/auth/o/google/cb',
        data: {
          'idToken': googleAuth.idToken,
          'accessToken': googleAuth.accessToken,
        },
      );
      print("7. Received response from backend: ${response.statusCode}");

      if (response.statusCode == 200 && response.data['success']) {
        print("8. Backend authentication successful");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        await prefs.setString('refreshToken', response.data['refreshToken']);
        print("9. Tokens saved to SharedPreferences");
        return User(id: response.data['userId'], email: googleUser.email);
      } else {
        print('10. Server response error: ${response.statusCode} - ${response.data}');
        return null;
      }
    } catch (e) {
      print('11. Error signing in with Google: $e');
      return null;
    }
  }
}