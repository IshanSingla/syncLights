import 'package:flutter/material.dart';
import 'package:synclights/utils/auth.dart';

class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
            height: 50,
            child: GestureDetector(
              onTap: () => signInWithGoogle(context),
              child: Text("Login with Google"),
            )),
      ),
    );
  }
}
