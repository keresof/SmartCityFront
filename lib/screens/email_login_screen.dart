import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_pop_scope.dart';
import '../providers/auth_provider.dart';

class EmailLoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  
                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter both email and password')),
                    );
                    return;
                  }

                  final success = await authProvider.signIn(email, password);
                  if (success) {
                    context.go('/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed. Please check your credentials.')),
                    );
                  }
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Forgot password functionality not implemented yet')),
                  );
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