import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_assignment/provider/auth_provider.dart';
import 'package:todo_assignment/screens/auth/sign_in.dart';
import 'package:todo_assignment/screens/newses/news_screen.dart';
import 'package:todo_assignment/services/payment_service.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Map<String, dynamic>? paymentIntent;
  final PaymentService _paymentService = PaymentService();

  String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            accountName: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            accountEmail: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(getUserEmail().toString())),
            //currentAccountPictureSize: Size.square(0),
            currentAccountPicture: Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 80,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Read News'),
            leading: Icon(
              Icons.newspaper,
              color: Colors.black.withOpacity(0.6),
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (builder) => Newses()));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Divider(),
          ),
          ListTile(
            title: Text('Donate Us'),
            leading: Icon(
              Icons.attach_money,
              color: Colors.black.withOpacity(0.6),
            ),
            onTap: () async {
              await _paymentService.makePayment(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Divider(),
          ),
          ListTile(
            title: Text('Log Out'),
            leading: Icon(
              Icons.logout,
              color: Colors.black.withOpacity(0.6),
            ),
            onTap: () {
              authProvider.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (builder) => SignInPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
