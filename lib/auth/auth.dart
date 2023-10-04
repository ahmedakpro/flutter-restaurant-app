import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/auth/login_or_register.dart';
import '../components/bottom_nav_bar.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return BottomNavBar();
          }

          // user is not logged in

          else if (snapshot.hasError) {
            print('Firebase Auth error:${snapshot.error.toString()}');
          }
          {
            return const LoginOrRegister();
          }
        }),
      ),
    );
  }
}
