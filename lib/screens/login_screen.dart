import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart City App Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildLogo(),
              SizedBox(height: 40),
              _buildLoginButton(
                context,
                'asset/image/google_logo.svg',
                'Login with Google',
                () {},
              ),
              SizedBox(height: 10),
              _buildLoginButton(
                context,
                'asset/image/facebook_logo.svg',
                'Login with Facebook',
                () {},
              ),
              SizedBox(height: 10),
              _buildLoginButton(
                context,
                'asset/image/instagram_logo.svg',
                'Login with Instagram',
                () {},
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/signup'),
                child: Text('Don\'t have an account? Sign Up'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: Text('Continue without login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Background color
                ),
              ),
            ],
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
          'Smart City App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, String? logoPath, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Colors.white,
        minimumSize: Size(double.infinity, 50),
        side: BorderSide(color: Colors.grey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (logoPath != null) ...[
            SvgPicture.asset(
              logoPath,
              height: 24,
            ),
            SizedBox(width: 10),
          ],
          Text(text),
        ],
      ),
    );
  }
}
