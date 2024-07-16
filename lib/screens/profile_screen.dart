import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_pop_scope.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      backPath: '/home',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
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
          child: Text('User Profile'),
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
          currentIndex: 2,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.push('/report');
                break;
              case 2:
                context.go('/profile');
                break;
            }
          },
        ),
      ),
    );
  }
}