import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_assignment/provider/auth_provider.dart';
import 'package:todo_assignment/responsive/mediaquery.dart';

import 'package:todo_assignment/screens/auth/sign_up.dart';
import 'package:todo_assignment/screens/home/home.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: context.height * 0.3,
                  width: context.width * 0.5,
                  child: Image.asset('assets/images/logo.png')),
              SizedBox(
                height: 20,
              ),
              Text(
                'WELCOME',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: context.width * 0.9,
                  height: context.height * 0.07,
                  padding: EdgeInsets.all(context.width * 0.03),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border:
                          Border.all(color: Color.fromARGB(255, 19, 0, 46))),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.email,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.7),
                        ),
                        SizedBox(
                          width: context.width * 0.04,
                        ),
                        Expanded(
                          child: TextField(
                            cursorColor: Theme.of(context).primaryColor,
                            controller: _emailController,
                            decoration: InputDecoration.collapsed(
                                hintText: 'abc@email.com',
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Container(
                  width: context.width * 0.9,
                  height: context.height * 0.07,
                  padding: EdgeInsets.all(context.width * 0.03),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border:
                          Border.all(color: Color.fromARGB(255, 19, 0, 46))),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.lock,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.7),
                        ),
                        SizedBox(
                          width: context.width * 0.04,
                        ),
                        Expanded(
                          child: TextField(
                            cursorColor: Theme.of(context).primaryColor,
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Your Password',
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              InkWell(
                onTap: () async {
                  try {
                    final String email = _emailController.text.trim();
                    final String password = _passwordController.text.trim();

                    if (email.isNotEmpty && password.isNotEmpty) {
                      await authProvider.signInWithEmailAndPassword(
                          email, password);
                      // Check if the user is authenticated
                      if (authProvider.user != null) {
                        //Sign-in successful, navigate to the desired screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else {
                        // Handle authentication failure

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Sign In Failed'),
                            content: const Text('Authentication failed.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    // Display an error message
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sign In Failed'),
                        content: Text('Error: $e'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                  height: context.height * 0.06,
                  width: context.width * 0.4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'LOG IN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'OR',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),
              Center(
                child: Container(
                  width: context.width * 0.45,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => SignUpPage()));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Create new account',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Theme.of(context).primaryColor,
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
