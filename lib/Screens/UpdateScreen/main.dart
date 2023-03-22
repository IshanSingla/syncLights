import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  UpdateState createState() => UpdateState();
}

class UpdateState extends State<UpdateScreen> {
  bool update = false;
  bool loading = true;
  String Link = "";
  void check() async {
    try {
      Map data = (await FirebaseFirestore.instance
              .collection('data')
              .doc("updater")
              .get())
          .data() as Map;
      loading = false;
      if (data["v"] != 1) {
        update = true;
        Link = data["link"];
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: loading ? Text("Loading") : Text("Loaded")));
  }
}
