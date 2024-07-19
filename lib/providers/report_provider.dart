import 'package:flutter/foundation.dart';
import '../services/report_service.dart';
import '../models/report.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();
  List<Report> _reports = [];

  List<Report> get reports => _reports;

  Future<void> createReport(Report report) async {
    try {
      final newReport = await _reportService.createReport(report);
      _reports.add(newReport);
      notifyListeners();
    } catch (e) {
      print('Error creating report: $e');
      rethrow;
    }
  }

  Future<void> updateReport(String id, Report report) async {
    try {
      final updatedReport = await _reportService.updateReport(id, report);
      final index = _reports.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reports[index] = updatedReport;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating report: $e');
      rethrow;
    }
  }

  Future<void> deleteReport(String id, String userId) async {
    try {
      await _reportService.deleteReport(id, userId);
      _reports.removeWhere((report) => report.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting report: $e');
      rethrow;
    }
  }

  Future<void> getReport(String id) async {
    try {
      final report = await _reportService.getReport(id);
      final index = _reports.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reports[index] = report;
      } else {
        _reports.add(report);
      }
      notifyListeners();
    } catch (e) {
      print('Error getting report: $e');
      rethrow;
    }
  }

  Future<void> searchReports({String? title, String? location}) async {
    try {
      _reports = await _reportService.searchReports(title: title, location: location);
      notifyListeners();
    } catch (e) {
      print('Error searching reports: $e');
      rethrow;
    }
  }

  Future<void> getReportsByUser(String userId) async {
    try {
      _reports = await _reportService.getReportsByUser(userId);
      notifyListeners();
    } catch (e) {
      print('Error getting user reports: $e');
      rethrow;
    }
  }
}