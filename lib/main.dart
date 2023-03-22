import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synclights/Components/EntryPoint.dart';
import 'package:synclights/Screens/HomeScreen/main.dart';
import 'package:synclights/Screens/UpdateScreen/main.dart';

// Pages
import 'package:synclights/firebase_options.dart';
import 'package:synclights/Screens/LoginScreen/main.dart';
import 'package:synclights/Screens/SplashScreen/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'SyncLights',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        "/splash": (context) => const SplashScreen(),
        "/home": (context) => const EntryPoint(child: HomeScreen()),
        "/login": (context) => const LoginScreen(),
        "/update": (context) => const UpdateScreen(),
      },
    );
  }
}
