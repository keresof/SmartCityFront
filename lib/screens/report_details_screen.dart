import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../models/report.dart';
import '../providers/report_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ReportDetailsScreen extends StatelessWidget {
  final dynamic report;

  const ReportDetailsScreen({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReportObject = report is Report;
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('report_details').tr(),
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
                    '${'title'.tr()}: ${isReportObject ? report.title : report['title']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${'category'.tr()}: ${isReportObject ? _getCategoryName(report.status) : _getCategoryName(report['status'])}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${'status'.tr()}: ${isReportObject ? _getStatusName(report.status) : _getStatusName(report['status'])}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'description'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(isReportObject
                      ? report.description
                      : report['description']),
                  SizedBox(height: 16),
                  Text(
                    '${'date'.tr()}: ${isReportObject ? report.lastModified.toString() : report['lastModifed'].toString()}',
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
                    target:
                        LatLng(report.coordinates[0], report.coordinates[1]),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('report_location'),
                      position:
                          LatLng(report.coordinates[0], report.coordinates[1]),
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
                      '${'images'.tr()}: ',
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
                            child: FutureBuilder<File>(
                              future: reportProvider
                                  .getFile(report.mediaUrls[index]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  return Image.file(
                                    snapshot.data!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  );
                                } else if (snapshot.hasError) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error),
                                  );
                                } else {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }
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
      'Yol Sorunu',
      'Çöp Sorunu',
      'Trafiğe İlişkin Sorun',
      'Su/Lağım Sorunu',
      'Halk Sağlığı Sorunu(Salgın, Haşere, vb.)',
      'Diğer',
    ];
    return status >= 0 && status < categories.length
        ? categories[status]
        : 'Unknown';
  }

  String _getStatusName(int status) {
    List<String> statuses = [
      'pending'.tr(),
      'processing'.tr(),
      'solved'.tr(),
      'closed'.tr()
    ];
    return status >= 0 && status < statuses.length
        ? statuses[status]
        : 'Unknown';
  }
}
