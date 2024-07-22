// lib/screens/report_details_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/report.dart';

class ReportDetailsScreen extends StatelessWidget {
  final dynamic report;

  const ReportDetailsScreen({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReportObject = report is Report;

    return Scaffold(
      appBar: AppBar(
        title: Text('Report Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title: ${isReportObject ? report.title : report['title']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Category: ${isReportObject ? _getCategoryName(report.status) : _getCategoryName(report['status'])}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Status: ${isReportObject ? _getStatusName(report.status) : _getStatusName(report['status'])}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(isReportObject ? report.description : report['description']),
                  SizedBox(height: 16),
                  Text(
                    'Date: ${isReportObject ? report.created.toString() : report['created'].toString()}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            if (isReportObject && report.coordinates.isNotEmpty)
              Container(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(report.coordinates[0], report.coordinates[1]),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('report_location'),
                      position: LatLng(report.coordinates[0], report.coordinates[1]),
                    ),
                  },
                ),
              ),
            if (isReportObject && report.mediaUrls.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Images:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: report.mediaUrls.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.network(
                              report.mediaUrls[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.error),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(int status) {
    List<String> categories = [
      'Road Issue',
      'Garbage',
      'Streetlight Problem',
      'Water Supply',
      'Public Safety',
      'Other'
    ];
    return status >= 0 && status < categories.length ? categories[status] : 'Unknown';
  }

  String _getStatusName(int status) {
    List<String> statuses = ['Pending', 'In Progress', 'Resolved', 'Closed'];
    return status >= 0 && status < statuses.length ? statuses[status] : 'Unknown';
  }
}