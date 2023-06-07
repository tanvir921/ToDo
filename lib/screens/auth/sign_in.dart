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
  bool _isSigningIn = false; // Track the sign-in progress

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    Color secondaryColor = Color.fromARGB(255, 255, 212, 1);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: context.height * 0.3,
                  width: context.width * 0.5,
                  child: Image.asset('assets/images/logo.png'),
                ),
                SizedBox(height: 20),
                Text(
                  'WELCOME',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                buildTextField(
                  context,
                  _emailController,
                  Icons.email,
                  'abc@email.com',
                ),
                const SizedBox(height: 16.0),
                buildTextField(
                  context,
                  _passwordController,
                  Icons.lock,
                  'Your Password',
                  obscureText: true,
                ),
                const SizedBox(height: 32.0),
                // Login button with progress indicator
                buildLoginButton(context, authProvider),
                SizedBox(height: 15),
                buildCreateAccountButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build a custom text field
  Widget buildTextField(BuildContext context, TextEditingController controller,
      IconData icon, String hint,
      {bool obscureText = false}) {
    return Center(
      child: Container(
        width: context.width * 0.9,
        height: context.height * 0.07,
        padding: EdgeInsets.all(context.width * 0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Color.fromARGB(255, 19, 0, 46)),
        ),
        child: Center(
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: Theme.of(context).primaryColor.withOpacity(0.7),
              ),
              SizedBox(width: context.width * 0.04),
              Expanded(
                child: TextField(
                  cursorColor: Theme.of(context).primaryColor,
                  controller: controller,
                  obscureText: obscureText,
                  decoration: InputDecoration.collapsed(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the login button
  Widget buildLoginButton(BuildContext context, AuthProvider authProvider) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color secondaryColor = Color.fromARGB(255, 255, 212, 1);

    return InkWell(
      onTap: _isSigningIn
          ? null
          : () async {
              try {
                final String email = _emailController.text.trim();
                final String password = _passwordController.text.trim();

                if (email.isNotEmpty && password.isNotEmpty) {
                  // Set the sign-in progress to true
                  setState(() {
                    _isSigningIn = true;
                  });

                  await authProvider.signInWithEmailAndPassword(
                      email, password);

                  // Check if the user is authenticated
                  if (authProvider.user != null) {
                    // Sign-in successful, navigate to the desired screen
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
              } finally {
                // Set the sign-in progress to false
                setState(() {
                  _isSigningIn = false;
                });
              }
            },
      child: Container(
        height: context.height * 0.06,
        width: context.width * 0.4,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: _isSigningIn
              ? SizedBox(
                  height: context.height * 0.03,
                  width: context.height * 0.03,
                  child: CircularProgressIndicator(
                    // Show circular progress indicator if signing in
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'LOG IN',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 17,
                  ),
                ),
        ),
      ),
    );
  }

  // Helper method to build the create account button
  Widget buildCreateAccountButton(BuildContext context) {
    return Center(
      child: Container(
        width: context.width * 0.45,
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (builder) => SignUpPage()),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create new account',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Theme.of(context).primaryColor,
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
