import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class GoogleSignInConfig {
  static Future<String> getClientId() async {
    final String content = await rootBundle.loadString('android/app/google_client_config.json');
    final Map<String, dynamic> json = jsonDecode(content);
    return json['installed']['client_id'];
  }
}