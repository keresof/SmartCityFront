import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/report.dart';
import 'auth_service.dart';

class ReportService {
  final String baseUrl = 'https://4065-85-102-229-52.ngrok-free.app/api';
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

  Future<Report> createReport(Report report) async {
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
      final String reportId = jsonDecode(response.body);
      return await getReport(reportId);
    } else {
      throw Exception('Failed to create report');
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
      throw Exception('Failed to update report');
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
        body: jsonEncode({'id': id, 'userId': userId}),
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete report');
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
      throw Exception('Failed to load report');
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
      throw Exception('Failed to search reports');
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
      throw Exception('Failed to load user reports');
    }
  }
}