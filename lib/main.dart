import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_assignment/screens/auth/sign_in.dart';
import 'package:todo_assignment/screens/home/home.dart';
import 'provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //firebase initializing
  Stripe.publishableKey =
      'pk_test_51LFqu7DbW0JoxU1Nj4kdyi89Wb6xF0qDoqRqQvNEjJn1tzNYI7LkF9eJ1kv9L7nMkDSYm530rc1QO9DBFU8nopEe00WqgmPgsr';
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theming
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 19, 0, 46),

        //primarySwatch: Colors.blue,
      ),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return StreamBuilder<User?>(
      stream: authProvider.firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
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
