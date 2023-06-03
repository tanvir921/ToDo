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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.logout),
            onTap: () {
              authProvider.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (builder) => SignInPage()),
              );
            },
          ),
          ListTile(
            title: Text('Read News'),
            leading: Icon(Icons.newspaper),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (builder) => Newses()));
            },
          ),
          ListTile(
            title: Text('Donate 5 Dollers'),
            leading: Icon(Icons.money),
            onTap: () async {
              await _paymentService.makePayment(context);
            },
          ),
        ],
      ),
    );
  }
}
