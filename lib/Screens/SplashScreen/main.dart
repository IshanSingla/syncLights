// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synclights/Components/scaffold.dart';
import 'package:synclights/utils/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), check); // add check function to run
  }

  Future<void> check() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user?.uid != null) {
        scaffold("Login Sucessfull", context);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        await signOut(context);
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      await signOut(context);
      scaffold(e.toString(), context);
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "SyncLights",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
