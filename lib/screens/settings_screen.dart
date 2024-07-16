import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_pop_scope.dart';
import '../models/app_state.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      backPath: '/home',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Consumer<AppState>(
          builder: (context, appState, child) {
            return ListView(
              children: [
                ListTile(
                  title: Text('Notifications'),
                  trailing: Switch(
                    value: appState.notificationsEnabled,
                    onChanged: (bool value) {
                      appState.toggleNotifications();
                    },
                  ),
                ),
                ListTile(
                  title: Text('Dark Mode'),
                  trailing: Switch(
                    value: appState.isDarkMode,
                    onChanged: (bool value) {
                      appState.toggleDarkMode();
                    },
                  ),
                ),
                ListTile(
                  title: Text('Language'),
                  trailing: DropdownButton<String>(
                    value: appState.language,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        appState.setLanguage(newValue);
                      }
                    },
                    items: <String>['English', 'Spanish', 'French', 'German']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  title: Text('Logout'),
                  onTap: () {
                    // TODO: Implement logout logic
                    appState.logout();
                    context.go('/');
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}