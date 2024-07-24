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
          title: Text('Ayarlar'),
        ),
        body: Consumer<AppState>(
          builder: (context, appState, child) {
            return ListView(
              children: [
                ListTile(
                  title: Text('Bildirimler'),
                  trailing: Switch(
                    value: appState.notificationsEnabled,
                    onChanged: (bool value) {
                      appState.toggleNotifications();
                    },
                  ),
                ),
                ListTile(
                  title: Text('Karanlık Mod'),
                  trailing: Switch(
                    value: appState.isDarkMode,
                    onChanged: (bool value) {
                      appState.toggleDarkMode();
                    },
                  ),
                ),
                ListTile(
                  title: Text('Dil'),
                  trailing: DropdownButton<String>(
                    value: appState.language,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        appState.setLanguage(newValue);
                      }
                    },
                    items: <String>['Türkçe', 'English', 'Espaniol', 'Deutch', 'Français']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  title: Text('Çıkış Yap'),
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