import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synclights/utils/CoustomColours.dart';
import 'package:synclights/utils/auth.dart';

class DrawerBody extends StatelessWidget {
  const DrawerBody({
    Key? key,
    required this.color,
  }) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    Color selectedColor = CustomColours.green;
    return Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: CustomColours.green,
              ),
              accountName: Text("${user?.displayName}"),
              accountEmail: Text("${user?.email}"),
              currentAccountPicture: CircleAvatar(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    user?.photoURL ??
                        'https://ui-avatars.com/api/?background=0D8ABC&color=fff&name=${user?.displayName ?? 'Full Name'}',
                  ),
                ),
              ),
            ),
            ListTile(
              selectedColor: selectedColor,
              iconColor: selectedColor,
              textColor: selectedColor,
              leading: const Icon(
                Icons.person,
                size: 30,
              ),
              title: const Text("Account Details"),
              subtitle:
                  Text("${user?.displayName}", style: TextStyle(color: color)),
            ),
            ListTile(
              selectedColor: selectedColor,
              iconColor: selectedColor,
              textColor: selectedColor,
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text("${user?.email}", style: TextStyle(color: color)),
            ),
            ListTile(
              selectedColor: selectedColor,
              iconColor: selectedColor,
              textColor: selectedColor,
              onTap: () {
                signOut(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              leading: const Icon(Icons.settings),
              title: Text("Sign out", style: TextStyle(color: color)),
            ),
          ],
        ));
  }
}
