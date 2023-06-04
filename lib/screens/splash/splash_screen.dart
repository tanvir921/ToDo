import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:todo_assignment/screens/home/auth_wrapper.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      // Set the logo as an image asset
      logo: Image.asset('assets/images/logo.png'),
      logoWidth: 100,
      backgroundColor: Colors.white,
      showLoader: true,
      // Set the navigator to the AuthenticationWrapper which determines the next screen
      navigator: AuthenticationWrapper(),
      durationInSeconds: 3,
    );
  }
}
