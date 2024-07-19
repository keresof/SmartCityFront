import 'package:flutter/material.dart';

import '../widgets/custom_pop_scope.dart';

class NotificationsScreen extends StatelessWidget {
  final List<String> notifications = [
    'Your report has been processed',
    'New city event: Summer Festival',
    'Reminder: City council meeting tomorrow',
    'Your suggestion has been approved',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      backPath: '/home',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(notifications[index]),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement notification detail view
              },
            );
          },
        ),
      ),
    );
  }
}