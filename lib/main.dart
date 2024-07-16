import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/home_screen.dart';
import 'screens/report_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/email_login_screen.dart';
import 'screens/notifications_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => LoginScreen(),
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
      GoRoute(
        path: '/email-login',
        builder: (context, state) => EmailLoginScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => NotificationsScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp.router(
            routerConfig: _router,
            title: 'Smart City App',
            theme: appState.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          );
        },
      ),
    );
  }
}