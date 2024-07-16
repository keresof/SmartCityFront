import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_pop_scope.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      backPath: '/',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {Future.microtask(() => context.go('/home'));}
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () => context.push('/otp'),
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}