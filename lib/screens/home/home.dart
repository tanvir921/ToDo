import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_assignment/provider/auth_provider.dart';
import 'package:todo_assignment/screens/drawer/drawer.dart';
import 'package:todo_assignment/screens/auth/sign_in.dart';
import 'package:todo_assignment/screens/home/todo/todo_form.dart';
import 'package:todo_assignment/screens/home/todo/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<DocumentSnapshot<Map<String, dynamic>>> snapshot = FirebaseFirestore
      .instance
      .collection('colors')
      .doc('colorDocument')
      .get();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the connection state
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'To Do',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              centerTitle: true,
              titleSpacing: 0,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                strokeWidth: 2,
              ),
            ),
          );
        } else if (snapshot.hasData && user != null) {
          // If the user is authenticated and data is available, display the home screen
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                // Show the add task dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Add Task'),
                    content: TodoForm(
                      userId: user.email.toString(),
                      color: '',
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: const Text(
                'To Do',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              centerTitle: true,
              titleSpacing: 0,
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                // Add sign out button or any other actions
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {},
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TodoList(userId: user.email.toString()),
                ),
              ],
            ),
          );
        } else {
          // If the user is not authenticated, navigate to the sign-in page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (builder) => SignInPage()));
          });
          return const Scaffold();
        }
      },
    );
  }
}
