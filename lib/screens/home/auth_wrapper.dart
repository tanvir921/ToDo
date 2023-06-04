import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_assignment/provider/auth_provider.dart';
import 'package:todo_assignment/screens/auth/sign_in.dart';
import 'package:todo_assignment/screens/home/home.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return StreamBuilder<User?>(
      stream: authProvider.firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            return ChangeNotifierProvider.value(
              value: authProvider,
              child: HomePage(),
            );
          } else {
            return SignInPage();
          }
        }
      },
    );
  }
}
