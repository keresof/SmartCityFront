// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> newsItems = [
    {
      'Başlık': 'Batıkent Rekrasyon Alanı Açılışı',
      '': 'Batıkent Rekreasyon Alanı açılış törenine tüm halkımız davetlidir.',
      'Tarih': '2024-03-15',
    },
    {
      'Başlık': 'Yol Çalışmaları',
      '': 'Anayol üzerindeki çalışmalar nedeniyle Gençlik Caddesi trafiğe kapanacaktır.',
      'Tarih': '2024-03-10',
    },
    {
      'Başlık': 'Bütçe Toplantısı',
      '': '2024 yılı bütçe toplantısında alınan kararlar..',
      'Tarih': '2024-03-20',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('smart_city_news').tr(),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: newsItems.length,
        itemBuilder: (context, index) {
          final news = newsItems[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(news['Başlık']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(news['']),
                  SizedBox(height: 4),
                  Text(
                    '${'date'.tr()}: ${news['Tarih']}',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              onTap: () {
                // TODO: Implement news detail view
              },
            ),
          );
        },
      ),
    );
  }
}
