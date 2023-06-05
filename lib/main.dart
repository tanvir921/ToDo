import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:todo_assignment/screens/splash/splash_screen.dart';
import 'package:todo_assignment/utils/app_constraints.dart';
import 'provider/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  Stripe.publishableKey =
      AppConstants.STRIPE_PUB_KEY; // Set Stripe publishable key
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                AuthProvider()), // Provide the AuthProvider using ChangeNotifierProvider
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
      // Theming
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 19, 0, 46),
        textTheme: GoogleFonts.aBeeZeeTextTheme(),
      ),
      home: SplashPage(), // Set the SplashPage as the initial screen
    );
  }
}
