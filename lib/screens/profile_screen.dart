// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/report_card.dart';

class ProfileScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reports = [
    {
      'category': 'Road Issue',
      'description': 'Large pothole on Main Street',
      'status': 'Pending',
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'category': 'Streetlight Problem',
      'description': 'Broken streetlight near Central Park',
      'status': 'In Progress',
      'date': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'category': 'Garbage',
      'description': 'Overflowing trash bins on Oak Avenue',
      'status': 'Resolved',
      'date': DateTime.now().subtract(const Duration(days: 10)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('John Doe'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'asset/image/profile_background.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                        CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('asset/image/profile.svg'),
                        ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            'john.doe@example.com',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement edit profile functionality
                    },
                    child: const Text('Edit Profile'),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your Reports',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final report = reports[index];
                return ReportCard(
                  category: report['category'],
                  description: report['description'],
                  status: report['status'],
                  date: report['date'],
                );
              },
              childCount: reports.length,
            ),
          ),
        ],
      ),
    );
  }
}
