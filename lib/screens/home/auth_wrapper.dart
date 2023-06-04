import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_assignment/provider/auth_provider.dart';
import 'package:todo_assignment/screens/auth/sign_in.dart';
import 'package:todo_assignment/screens/home/home.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return StreamBuilder<User?>(
      stream: authProvider.firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the connection state
          return Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            )),
          );
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            // If the user is authenticated, provide the authProvider and navigate to HomePage
            return ChangeNotifierProvider.value(
              value: authProvider,
              child: HomePage(),
            );
          } else {
            // If the user is not authenticated, show the SignInPage
            return SignInPage();
          }
        }
      },
    );
  }
}
