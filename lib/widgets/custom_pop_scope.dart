import 'package:flutter/material.dart';
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
    return PopScope(
      onPopInvoked: (isExiting) {
        if (isExiting) {
          if (isRoot) {
            _showExitConfirmationDialog(context);
          } else if (backPath != null) {
            context.go(backPath!);
          }
        }
      },
      child: child,
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
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
                Navigator.of(context).pop(true); // Actually exit the app
              },
            ),
          ],
        );
      },
    );
  }
}