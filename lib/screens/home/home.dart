import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_assignment/provider/auth_provider.dart';
import 'package:todo_assignment/screens/drawer/drawer.dart';
import 'package:todo_assignment/screens/auth/sign_in.dart';
import 'package:todo_assignment/screens/home/custom/todo_form.dart';
import 'package:todo_assignment/screens/home/custom/todo_list.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        } else if (snapshot.hasData && user != null) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Add Task'),
                    content: TodoForm(userId: user.uid),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            drawer: const CustomDrawer(),
            appBar: AppBar(
              title: const Text('To Do'),
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                //Sign Out Button
                IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {},
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TodoList(userId: user.uid),
                  ),
                ],
              ),
            ),
          );
        } else {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (builder) => SignInPage()));
          });
          return const Scaffold();
        }
      },
    );
  }
}
