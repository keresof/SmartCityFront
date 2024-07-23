// lib/services/report_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/report.dart';
import 'auth_service.dart';

class ReportService {
  static const String baseUrl = 'https://smartcity.demo.xn--glolu-jua30a.com/api';
  final AuthService _authService = AuthService();

  Future<String?> _getToken() async {
    return await _authService.getToken();
  }

  Future<http.Response> _authenticatedRequest(
    Future<http.Response> Function() requestFunction
  ) async {
    final response = await requestFunction();
    if (response.statusCode == 401) {
      final refreshSuccess = await _authService.refreshToken();
      if (refreshSuccess) {
        return await requestFunction();
      }
    }
    return response;
  }

  Future<String> createReport(Report report) async {
    final token = await _getToken();
    final response = await _authenticatedRequest(() => 
      http.post(
        Uri.parse('$baseUrl/reports'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(report.toJson()),
      )
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create report: ${response.body}');
    }
  }

  Future<Report> updateReport(String id, Report report) async {
    final token = await _getToken();
    final response = await _authenticatedRequest(() => 
      http.put(
        Uri.parse('$baseUrl/reports/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(report.toJson()),
      )
    );

    if (response.statusCode == 200) {
      return await getReport(id);
    } else {
      throw Exception('Failed to update report: ${response.body}');
    }
  }

  Future<void> deleteReport(String id, String userId) async {
    final token = await _getToken();
    final response = await _authenticatedRequest(() => 
      http.delete(
        Uri.parse('$baseUrl/reports/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'userId': userId}),
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete report: ${response.body}');
    }
  }

  Future<Report> getReport(String id) async {
    final token = await _getToken();
    final response = await _authenticatedRequest(() => 
      http.get(
        Uri.parse('$baseUrl/reports/$id'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      )
    );

    if (response.statusCode == 200) {
      return Report.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load report: ${response.body}');
    }
  }

  Future<List<Report>> searchReports({String? title, String? location}) async {
    final token = await _getToken();
    final queryParameters = <String, String>{};
    if (title != null) queryParameters['title'] = title;
    if (location != null) queryParameters['location'] = location;

    final uri = Uri.parse('$baseUrl/reports/search').replace(queryParameters: queryParameters);
    final response = await _authenticatedRequest(() => 
      http.get(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      )
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Report.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search reports: ${response.body}');
    }
  }

  Future<List<Report>> getReportsByUser(String userId) async {
    final token = await _getToken();
    final response = await _authenticatedRequest(() => 
      http.get(
        Uri.parse('$baseUrl/reports/user/$userId'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      )
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Report.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load user reports: ${response.body}');
    }
  }

  Future<String> uploadFile(String reportId, File file) async {
    try {
      final token = await _getToken();
      final url = Uri.parse('$baseUrl/reports/$reportId/upload');

      var request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('image', 'jpeg'), // Adjust based on your file type
        ))
        ..headers['Authorization'] = 'Bearer $token';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['url'];
      } else {
        throw Exception('Failed to upload image: ${response.body}');
      }
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }

  Future<File> getFile(String fileName) async {
    final token = await _getToken();
    final response = await _authenticatedRequest(() => 
      http.get(
        Uri.parse('$baseUrl/reports/media/$fileName'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      )
    );

    if (response.statusCode == 200) {
      final tempDir = await Directory.systemTemp.createTemp();
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(response.bodyBytes);
      return tempFile;
    } else {
      throw Exception('Failed to get file: ${response.body}');
    }
  }
}