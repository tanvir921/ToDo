import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_assignment/screens/auth/sign_in.dart';
import 'package:todo_assignment/screens/home/home.dart';
import 'package:todo_assignment/screens/splash/splash_screen.dart';
import 'provider/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
        textTheme: GoogleFonts.robotoSlabTextTheme(),
        //primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}
