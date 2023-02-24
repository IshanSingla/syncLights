import 'package:flutter/material.dart';
import 'package:synclights/utils/auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
          width: size.width * 0.5,
          height: 40,
          child: SignInButton(
            Buttons.Google,
            onPressed: () => signInWithGoogle(context),
          )),
    );
  }
}
