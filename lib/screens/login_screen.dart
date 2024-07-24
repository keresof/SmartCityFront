import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_pop_scope.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return CustomPopScope(
      isRoot: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Akıllı Şehir Uygulaması'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildLogo(),
                SizedBox(height: 40),
                if (!authProvider.isAuthenticated) ...[
                  _buildLoginButton(
                    context,
                    'asset/image/google_logo.svg',
                    'Google ile Giriş Yap',
                    () => _handleGoogleSignIn(context),
                  ),
                  SizedBox(height: 10),
                  _buildLoginButton(
                    context,
                    'asset/image/facebook_logo.svg',
                    'Facebook ile Giriş Yap',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Facebook ile kayıt YAKINDA!')),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  _buildLoginButton(
                    context,
                    'asset/image/instagram_logo.svg',
                    'Instagram ile Giriş Yap',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Instagram ile kayıt YAKINDA!')),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.go('/signup'),
                    child: Text('Henüz hesabınız yok mu? Kaydolun'),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () => context.go('/email-login'),
                    child: Text('Email ile Giriş Yap'),
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: Text('Devam Et'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        SvgPicture.asset(
          'asset/image/app_logo.svg',
          height: 100,
        ),
        Text(
          'Akıllı Şehir',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithGoogle();

    if (success) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google ile giriş başarısız. Lütfen tekrar deneyin.')),
      );
    }
  }

  Widget _buildLoginButton(BuildContext context, String logoPath, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        minimumSize: Size(double.infinity, 50),
        side: BorderSide(color: Colors.grey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            logoPath,
            height: 24,
          ),
          SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}