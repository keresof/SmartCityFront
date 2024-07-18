import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_pop_scope.dart';

class OTPScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      backPath: '/signup',
      child: Scaffold(
        appBar: AppBar(
          title: Text('OTP Verification'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {Future.microtask(() => context.go('/signup'));},
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: otpController,
                decoration: InputDecoration(labelText: 'Enter OTP'),
              ),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}