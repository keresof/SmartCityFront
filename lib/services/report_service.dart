import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/report.dart';

class ReportService {
  //TODO: BURAYA DOĞRU BİR ŞEYLER YAZILACAK VE MAGIC HAPPENS
   final String baseUrl = 'http://192.168.221.39:5026/api'; 

  Future<Report> createReport(Report report) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Reports'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(report.toJson()),
    );

    if (response.statusCode == 201) {
      return Report.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create report');
    }
  }

  Future<Report> updateReport(String id, Report report) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Reports/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(report.toJson()),
    );

    if (response.statusCode == 200) {
      return Report.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update report');
    }
  }

  Future<void> deleteReport(String id, String userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/Reports/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id, 'userId': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete report');
    }
  }

  Future<Report> getReport(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/Reports/$id'));

    if (response.statusCode == 200) {
      return Report.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load report');
    }
  }

  Future<List<Report>> searchReports({String? title, String? location}) async {
    final queryParameters = <String, String>{};
    if (title != null) queryParameters['title'] = title;
    if (location != null) queryParameters['location'] = location;

    final uri = Uri.parse('$baseUrl/Reports/search').replace(queryParameters: queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Report.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search reports');
    }
  }

  Future<List<Report>> getReportsByUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/Reports/user/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Report.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load user reports');
    }
  }
}