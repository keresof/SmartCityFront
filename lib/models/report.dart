// lib/models/report.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Report {
  final String id;
  final String category;
  final String description;
  final LatLng location;
  final String address;
  final List<String> imagePaths;
  final String status;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.category,
    required this.description,
    required this.location,
    required this.address,
    required this.imagePaths,
    this.status = 'Pending',
    required this.createdAt,
  });
}