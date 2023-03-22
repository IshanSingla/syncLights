// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synclights/Components/scaffold.dart';
import 'package:synclights/Screens/SplashScreen/Components/body.dart';
import 'package:synclights/utils/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), check); // add check function to run
  }

  Future<void> check() async {
    try {
      FirebaseFirestore instance = FirebaseFirestore.instance;
      instance.settings = const Settings(
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      Map data = (await instance.collection('data').doc("updater").get()).data()
          as Map;
      print(data);
      if (data["v"] != 1) {
        Navigator.pushReplacementNamed(context, '/update');
      } else {
        User? user = FirebaseAuth.instance.currentUser;
        if (user?.uid != null) {
          scaffold("Login Sucessfull", context);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          await signOut(context);
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      await signOut(context);
      scaffold(e.toString(), context);
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Body(),
    );
  }
}
