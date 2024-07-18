// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../widgets/report_card.dart';
import '../models/report.dart';
import '../models/user_reports.dart';

class ProfileScreen extends StatelessWidget {
  final List<Map<String, dynamic>> mockReports = [
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
    final userReports = UserReports.getReports();
    final allReports = [...userReports, ...mockReports];

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
                        child: SvgPicture.asset(
                          'asset/image/profile.svg',
                          fit: BoxFit.cover,)
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
                final report = allReports[index];
                return GestureDetector(
                  onTap: () {
                    context.push('/report-details', extra: report);
                  },
                  child: report is Report
                    ? ReportCard(
                        category: report.category,
                        description: report.description,
                        status: report.status,
                        date: report.createdAt,
                      )
                    : ReportCard(
                        category: (report as Map<String, dynamic>)['category'],
                        description: (report)['description'],
                        status: (report)['status'],
                        date: (report)['date'],
                      ),
                );
              },
              childCount: allReports.length,
            ),
          ),
        ],
      ),
    );
  }
}