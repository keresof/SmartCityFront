import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_pop_scope.dart';

class EmailLoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      backPath: '/',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login with Email'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement email login logic
                  context.go('/home');
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // TODO: Implement forgot password functionality
                },
                child: Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}