// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> newsItems = [
    {
      'title': 'New City Park Opening',
      'description': 'Grand opening of Central Park scheduled for next month.',
      'date': '2024-03-15',
    },
    {
      'title': 'Road Construction Update',
      'description': 'Main Street construction to be completed by end of week.',
      'date': '2024-03-10',
    },
    {
      'title': 'City Council Meeting',
      'description': 'Next city council meeting to discuss budget allocation.',
      'date': '2024-03-20',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart City News'),
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
              title: Text(news['title']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(news['description']),
                  SizedBox(height: 4),
                  Text(
                    'Date: ${news['date']}',
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