import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;
  FirebaseAuth get firebaseAuth => _firebaseAuth;

  AuthProvider() {
    // Listen to auth state changes and update the user accordingly
    _firebaseAuth.authStateChanges().listen((User? currentUser) {
      _user = currentUser;
      notifyListeners();
    });
  }

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Sign in failed: $e');
      throw e;
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Sign up failed: $e');
      throw e;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Sign out failed: $e');
      throw e;
    }
  }
}
