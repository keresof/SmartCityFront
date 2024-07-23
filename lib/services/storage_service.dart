// lib/services/storage_service.dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import '../services/auth_service.dart';

class StorageService {
  final String baseUrl = 'https://smartcity.demo.xn--glolu-jua30a.com/api'; // Update with your API URL
  final AuthService _authService = AuthService();

  Future<String> uploadFile(File file) async {
    try {
      final token = await _authService.getToken();
      final url = Uri.parse('$baseUrl/reports/upload');

      var request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('image', 'jpeg'), // Adjust based on your file type
        ))
        ..headers['Authorization'] = 'Bearer $token';

      var response = await request.send();
      
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['url'];
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }
}
