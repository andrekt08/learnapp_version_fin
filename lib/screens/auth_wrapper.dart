import 'package:education_app_ui/screens/authenticate/authenticate_screen.dart';
import 'package:education_app_ui/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    // return either Authenticate or Home widget
    if (user == null) {
      return const AuthenticateScreen();
    } else {
      return HomePage();
    }
  }
}
