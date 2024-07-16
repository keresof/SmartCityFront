import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/report.dart';

class ReportService {
  final Dio _dio = Dio();

  Future<void> submitReport(String description, XFile image) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final formData = FormData.fromMap({
      'description': description,
      'image': await MultipartFile.fromFile(image.path),
    });

    await _dio.post(
      'https://your-backend-url.com/api/reports',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<List<Report>> fetchReports() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await _dio.get(
      'https://your-backend-url.com/api/reports',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((data) => Report.fromJson(data))
          .toList();
    }
    return [];
  }
}
