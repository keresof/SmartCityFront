import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/report_card.dart';
import '../providers/report_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user reports when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reportProvider = Provider.of<ReportProvider>(context, listen: false);
      reportProvider.getReportsByUser("3fa85f64-5717-4562-b3fc-2c963f66afa6"); // Replace with actual user ID
    });
  }

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
                        child: SvgPicture.asset(
                          'asset/image/profile.svg',
                          fit: BoxFit.cover,
                        )
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
          Consumer<ReportProvider>(
            builder: (context, reportProvider, child) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final report = reportProvider.reports[index];
                    return GestureDetector(
                      onTap: () {
                        context.push('/report-details', extra: report);
                      },
                      child: ReportCard(report: report),
                    );
                  },
                  childCount: reportProvider.reports.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}