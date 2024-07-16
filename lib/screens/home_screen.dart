import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_pop_scope.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      isRoot: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
  icon: Icon(Icons.settings),
  onPressed: () => context.push('/settings'),
),
           IconButton(
  icon: Icon(Icons.notifications),
  onPressed: () => context.push('/notifications'),
),
          ],
        ),
        body: Center(
          child: Text('Home - Feedbacks and News'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label: 'Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: 0,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.push('/report');
                break;
              case 2:
                context.push('/profile');
                break;
            }
          },
        ),
      ),
    );
  }
}