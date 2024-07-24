import 'package:flutter/material.dart';

import '../widgets/custom_pop_scope.dart';

class NotificationsScreen extends StatelessWidget {
  final List<String> notifications = [
    'Raporunuz işleme alındı',
    'Yol çalışmaları başladı',
    'Büyük park açılışı ertelendi',
    'Öneriniz sayesinde şunları yaptık ..',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      backPath: '/home',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bildirimler'),
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