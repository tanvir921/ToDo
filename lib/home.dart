import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:todo_assignment/auth_provider.dart';
import 'package:todo_assignment/sign_in.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && user != null) {
          return Scaffold(
            drawer: Drawer(
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
                            MaterialPageRoute(
                                builder: (builder) => SignInPage()));
                      },
                    ),
                    ListTile(
                      title: Text('Read News'),
                      leading: Icon(Icons.newspaper),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Donate 5 Dollers'),
                      leading: Icon(Icons.money),
                      onTap: () async {
                        await makePayment();
                      },
                    ),
                  ]),
            ),
            appBar: AppBar(
              title: Text('Home Page'),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    authProvider.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (builder) => SignInPage()));
                  },
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
                  SizedBox(height: 16),
                  FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Add Task'),
                          content: TodoForm(userId: user.uid),
                        ),
                      );
                    },
                    child: Icon(Icons.add),
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
          return Scaffold();
        }
      },
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('5', 'USD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Tanvir Ahmed'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        // Payment successful
        // Save payment ID, amount, and date to Firebase database
        savePaymentToFirebase(
          paymentIntent!['id'],
          paymentIntent!['amount'],
        );

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    Text("Payment Successful"),
                  ],
                ),
              ],
            ),
          ),
        );

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Cancelled"),
        ),
      );
    } catch (e) {
      print('$e');
    }
  }


  void savePaymentToFirebase(String paymentId, int amount) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final collectionRef = FirebaseFirestore.instance.collection('payments');
      final userPaymentsRef = collectionRef.doc(user.uid).collection('userPayments');

      userPaymentsRef.add({
        'paymentId': paymentId,
        'amount': amount/100,
        'date': DateTime.now().toIso8601String(),
      }).then((value) {
        print('Payment saved to Firebase: $paymentId, $amount');
      }).catchError((error) {
        print('Failed to save payment to Firebase: $error');
      });
    }
  }





  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51LFqu7DbW0JoxU1NcWXAO10CAUKcrHgODSqwxeUleGbV5TC9RDQePyMgSIzaFKbxyrfIYOKWFvhk3xeakhvZnmsH00qG6iGVU3',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}

class TodoList extends StatelessWidget {
  final String userId;

  TodoList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('todos')
          .doc(userId)
          .collection('tasks')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final task = documents[index];
              final String title = task['title'];
              final String description = task['description'];
              final bool isDone = task['isDone'] ?? false;

              return ListTile(
                leading: Checkbox(
                  value: isDone,
                  onChanged: (value) {
                    FirebaseFirestore.instance
                        .collection('todos')
                        .doc(userId)
                        .collection('tasks')
                        .doc(task.id)
                        .update({'isDone': value});
                  },
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  description,
                  style: TextStyle(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Edit Task'),
                        content: TodoForm(
                          userId: userId,
                          initialTitle: title,
                          initialDescription: description,
                          taskId: task.id,
                        ),
                      ),
                    );
                  },
                ),
                onLongPress: () {
                  FirebaseFirestore.instance
                      .collection('todos')
                      .doc(userId)
                      .collection('tasks')
                      .doc(task.id)
                      .delete();
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error loading tasks');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class TodoForm extends StatefulWidget {
  final String userId;
  final String? initialTitle;
  final String? initialDescription;
  final String? taskId;

  TodoForm({
    required this.userId,
    this.initialTitle,
    this.initialDescription,
    this.taskId,
  });

  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              final String title = _titleController.text.trim();
              final String description = _descriptionController.text.trim();

              if (title.isNotEmpty && description.isNotEmpty) {
                if (widget.taskId != null) {
                  FirebaseFirestore.instance
                      .collection('todos')
                      .doc(widget.userId)
                      .collection('tasks')
                      .doc(widget.taskId)
                      .update({
                    'title': title,
                    'description': description,
                  });
                } else {
                  FirebaseFirestore.instance
                      .collection('todos')
                      .doc(widget.userId)
                      .collection('tasks')
                      .add({
                    'title': title,
                    'description': description,
                    'isDone': false,
                  });
                }

                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
