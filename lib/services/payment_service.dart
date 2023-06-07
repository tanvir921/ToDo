import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:todo_assignment/utils/app_constraints.dart';

class PaymentService {
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(BuildContext context) async {
    try {
      paymentIntent = await createPaymentIntent('5', 'USD');
      // Payment Sheet initialization
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Tanvir Ahmed',
        ),
      );

      // Display Payment Sheet
      await displayPaymentSheet(context);
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  Future<void> displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();

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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Payment Successful"),
                ],
              ),
            ],
          ),
        ),
      );

      paymentIntent = null;
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel_rounded,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Cancelled"),
                ],
              ),
            ],
          ),
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
      final userPaymentsRef =
          collectionRef.doc(user.email).collection('userPayments');

      userPaymentsRef.add({
        'paymentId': paymentId,
        'amount': "\$${amount / 100}",
        'date': DateTime.now().toIso8601String(),
      }).then((value) {
        print('Payment saved to Firebase: $paymentId, $amount');
      }).catchError((error) {
        print('Failed to save payment to Firebase: $error');
      });
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${AppConstants.STRIPE_SECRET_KEY}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
      throw err;
    }
  }

  String calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
