import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class CustomPopScope extends StatelessWidget {
  final Widget child;
  final String? backPath;
  final bool isRoot;

  const CustomPopScope({
    Key? key,
    required this.child,
    this.backPath,
    this.isRoot = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isRoot) {
          final shouldPop = await _showExitConfirmationDialog(context);
          return shouldPop;
        } else if (backPath != null) {
          context.go(backPath!);
          return false;
        }
        return true;
      },
      child: child,
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit App'),
          content: Text('Are you sure you want to exit?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result == true) {
      SystemNavigator.pop(); // This will close the app
    }

    return false; // Prevent default back button behavior
  }
}