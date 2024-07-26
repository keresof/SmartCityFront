import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_pop_scope.dart';
import '../providers/auth_provider.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return CustomPopScope(
      backPath: '/',
      child: Scaffold(
        appBar: AppBar(
          title: Text('register').tr(),
          leading: IconButton(
              icon: Icon(Icons.arrow_back), onPressed: () => context.go('/')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'email'.tr()),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'password'.tr()),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final success = await authProvider.signUp(
                        emailController.text, passwordController.text);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('signup_success').tr()));
                      context.go('/');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('signup_failed').tr()));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${'error'.tr()}: $e')));
                  }
                },
                child: Text('register').tr(),
              ),
              // Commented out OTP navigation
              // ElevatedButton(
              //   onPressed: () => context.go('/otp'),
              //   child: Text('Sign Up'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
