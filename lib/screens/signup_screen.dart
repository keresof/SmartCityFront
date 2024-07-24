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
          title: Text('Kaydol'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => context.go('/')
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Şifre'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final success = await authProvider.signUp(
                      emailController.text,
                      passwordController.text
                    );
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Kayıt başarılı. Lütfen giriş yapın.'))
                      );
                      context.go('/');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Kayıt başarısız. Lütfen tekrar deneyin.'))
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bir hata meydana geldi!: $e'))
                    );
                  }
                },
                child: Text('Kaydol'),
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