import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synclights/utils/auth.dart';

class DrawerBody extends StatelessWidget {
  const DrawerBody({
    Key? key,
    required this.user,
    required this.color,
  }) : super(key: key);
  final User? user;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(user?.displayName ?? 'Full Name'),
          accountEmail: Text(user?.email ?? 'new@gmail.com'),
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
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: const ListTile(
            leading: Icon(
              Icons.person,
              size: 30,
            ),
            title: Text("Account"),
            subtitle: Text("Personal"),
            trailing: Icon(Icons.edit),
            autofocus: true,
          ),
        ),
        ListTile(
          leading: Icon(Icons.email),
          title: Text('Email'),
          subtitle: Text(user?.email ?? 'new@gmail.com'),
        ),
        const ListTile(
          leading: Icon(Icons.send),
          title: Text("Share"),
        ),
        GestureDetector(
          onTap: () {
            signOut(context);
          },
          child: ListTile(
            leading: const Icon(Icons.settings),
            title: Text("Sign out", style: TextStyle(color: color)),
          ),
        ),
      ],
    );
  }
}
