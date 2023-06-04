import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_assignment/screens/auth/sign_in.dart';
import 'package:todo_assignment/screens/drawer/drawer.dart';
import 'package:todo_assignment/screens/home/home.dart';
import 'package:todo_assignment/screens/home/todo/todo_form.dart';
import 'provider/auth_provider.dart';

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

        //primarySwatch: Colors.blue,
      ),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return StreamBuilder<User?>(
      stream: authProvider.firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  final user = authProvider.user;
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Add Task'),
                      content: TodoForm(userId: user!.uid),
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
                    icon: const Icon(Icons.favorite),
                    onPressed: () {},
                  ),
                ],
              ),
              body: Center(
                  child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              )));
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            return ChangeNotifierProvider.value(
              value: authProvider,
              child: HomePage(),
            );
          } else {
            return SignInPage();
          }
        }
      },
    );
  }
}
