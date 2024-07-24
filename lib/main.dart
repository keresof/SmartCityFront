// lib/main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_city_app/screens/report_details_screen.dart';
import 'models/app_state.dart';
import 'providers/report_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/map_selections_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/home_screen.dart';
import 'screens/report_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/email_login_screen.dart';
import 'screens/notifications_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp.router(
          routerConfig: _router(authProvider),
          title: 'Akıllı Şehir Uygulaması',
          theme: context.watch<AppState>().isDarkMode
              ? ThemeData.dark()
              : ThemeData.light(),
        );
      },
    );
  }

  GoRouter _router(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/',
    
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: '/report-details',
          builder: (context, state) => ReportDetailsScreen(report: state.extra),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => SignUpScreen(),
        ),
        GoRoute(
          path: '/otp',
          builder: (context, state) => OTPScreen(),
        ),
        GoRoute(
          path: '/email-login',
          builder: (context, state) => EmailLoginScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return ScaffoldWithNavBar(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => HomeScreen(),
            ),
            GoRoute(
              path: '/report',
              builder: (context, state) => ReportScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfileScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => NotificationsScreen(),
        ),
        GoRoute(
          path: '/map-selection',
          builder: (context, state) => MapSelectionScreen(),
        ),
      ],
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Sana Özel'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Rapor'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/report')) {
      return 1;
    }
    if (location.startsWith('/profile')) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/home');
        break;
      case 1:
        GoRouter.of(context).go('/report');
        break;
      case 2:
        GoRouter.of(context).go('/profile');
        break;
    }
  }
}