import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background/Splash.png'),
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
      ))
    ]);
  }
}
