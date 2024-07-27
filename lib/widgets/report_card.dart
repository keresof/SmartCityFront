import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../models/report.dart';

class ReportCard extends StatelessWidget {
  final Report report;

  const ReportCard({
    Key? key,
    required this.report,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                _buildStatusChip(),
              ],
            ),
            SizedBox(height: 8),
            Text(
              report.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Text(
              'report_date'.tr() +
                  ': ${_formatDate(report.lastModified ?? DateTime.now())}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color statusColor;
    String statusText;
    switch (report.status) {
      case 0:
        statusColor = Colors.orange;
        statusText = 'pending'.tr();
        break;
      case 1:
        statusColor = Colors.blue;
        statusText = 'processing'.tr();
        break;
      case 2:
        statusColor = Colors.green;
        statusText = 'solved'.tr();
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'unknown'.tr();
    }

    return Chip(
      label: Text(
        statusText,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: statusColor,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
