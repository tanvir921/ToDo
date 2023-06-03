import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_assignment/provider/auth_provider.dart';
import 'package:todo_assignment/responsive/mediaquery.dart';
import 'package:todo_assignment/screens/auth/sign_in.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    Color secondaryColor = Color.fromARGB(255, 255, 212, 1);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: context.height * 0.3,
                width: context.width * 0.5,
                child: Image.asset('assets/images/logo.png')),
            SizedBox(
              height: 20,
            ),
            Text(
              'REGISTER',
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
                    border: Border.all(color: Color.fromARGB(255, 19, 0, 46))),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
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
                    border: Border.all(color: Color.fromARGB(255, 19, 0, 46))),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.lock,
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
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
            SizedBox(height: 32.0),
            InkWell(
              onTap: () async {
                try {
                  final String email = _emailController.text.trim();
                  final String password = _passwordController.text.trim();

                  if (email.isNotEmpty && password.isNotEmpty) {
                    await authProvider.signUpWithEmailAndPassword(
                        email, password);
                    // Sign-up successful, navigate to the sign-in page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  }
                } catch (e) {
                  // Display an error message
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Sign Up Failed'),
                      content: Text('Error: $e'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
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
                    'SIGN UP',
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
