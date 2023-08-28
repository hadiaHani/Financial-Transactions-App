import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g_final_project/models/response.dart';
import 'package:g_final_project/screens/login.dart';

class FbAuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Response> signIn(String email, String password, context) async {
    try {
      var response = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (response.user!.emailVerified) {
        return Response('Logged in successfully', true);
      } else {
        return Response('Login failed, verify email!', false);
      }
    } on FirebaseAuthException catch (e) {
      return Response(e.message ?? "", false);
    }
  }

  Future<void> signOut(context) async {
    await auth.signOut().then((value) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (contex) => const LoginPage()));
    });
  }

  Future<bool> createUser(String email, String password, context) async {
    try {
      var response = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await response.user!.sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${e.message}"),
          backgroundColor: Colors.blueGrey,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  bool get loggedIn => auth.currentUser != null;
}
