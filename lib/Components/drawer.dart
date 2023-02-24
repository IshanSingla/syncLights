import 'package:flutter/material.dart';
import 'drawer_body.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;
    return Drawer(
        child: DrawerBody(
      color: color,
    ));
  }
}
