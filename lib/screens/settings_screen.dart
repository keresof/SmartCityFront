import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/custom_pop_scope.dart';
import '../models/app_state.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      backPath: '/home',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('settings').tr(),
        ),
        body: Consumer2<AppState, AuthProvider>(
          builder: (context, appState, authProvider, child) {
            return ListView(
              children: [
                ListTile(
                  title: const Text('notifications').tr(),
                  trailing: Switch(
                    value: appState.notificationsEnabled,
                    onChanged: (bool value) {
                      appState.toggleNotifications();
                    },
                  ),
                ),
                ListTile(
                  title: const Text('darkMode').tr(),
                  trailing: Switch(
                    value: appState.isDarkMode,
                    onChanged: (bool value) {
                      appState.toggleDarkMode();
                    },
                  ),
                ),
                ListTile(
                  title: const Text('language').tr(),
                  trailing: DropdownButton<String>(
                    value: appState.language,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        appState.setLanguage(newValue);
                        context.setLocale(Locale(newValue));
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 'tr', child: Text('🇹🇷 Türkçe')),
                      DropdownMenuItem(
                          value: 'en', child: Text('🇺🇸 English')),
                      DropdownMenuItem(
                          value: 'es', child: Text('🇪🇸 Español')),
                      DropdownMenuItem(
                          value: 'de', child: Text('🇩🇪 Deutsch')),
                      DropdownMenuItem(
                          value: 'fr', child: Text('🇫🇷 Français')),
                      DropdownMenuItem(
                          value: 'ar', child: Text('العربية 🇸🇦')),
                    ],
                  ),
                ),
                if (authProvider.isAuthenticated)
                  ListTile(
                    title: const Text('logout').tr(),
                    onTap: () {
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
