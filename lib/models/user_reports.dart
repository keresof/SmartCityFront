// lib/models/user_reports.dart
import 'report.dart';

class UserReports {
  static List<Report> _reports = [];

  static void addReport(Report report) {
    _reports.add(report);
  }

  static List<Report> getReports() {
    return List.from(_reports);
  }
}