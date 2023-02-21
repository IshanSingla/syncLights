// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:synclights/Components/scaffold.dart';

Future<void> signOut(BuildContext context) async {
  try {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    scaffold(e.toString(), context);
  }
}

Future<void> check(BuildContext context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user?.uid != null) {
      scaffold("Login Sucessfull", context);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      await signOut(context);
    }
  } catch (e) {
    await signOut(context);
    scaffold(e.toString(), context);
    Navigator.pushReplacementNamed(context, '/login');
  }
}

Future<void> signInWithGoogle(dynamic context) async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  await FirebaseAuth.instance.signInWithCredential(credential);
  await check(context);
}
