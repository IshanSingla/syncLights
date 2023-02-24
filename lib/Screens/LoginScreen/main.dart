import 'package:flutter/material.dart';
import 'components/body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background/Login.png'),
              fit: BoxFit.cover),
        ),
      ),
      Center(
          child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          height: 150,
          width: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/logo/logo.png'), fit: BoxFit.cover),
          ),
        ),
      )),
      const Body()
    ]));
  }
}
