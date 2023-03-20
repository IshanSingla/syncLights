// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//
import 'package:synclights/Screens/HomeScreen/components/ListGrids.dart';
import 'package:synclights/data/lights.dart';
import 'package:synclights/utils/CoustomColours.dart';

class DraggableScrollable extends StatefulWidget {
  IO.Socket socket =
      IO.io("https://syncllight.herokuapp.com/", <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": true,
  });
  DraggableScrollable({super.key}) {
    socket.connect();
    socket.onConnect((data) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        socket.emit("changeId", "user_${user.uid}");
      }
    });
  }
  @override
  DraggableScrollableState createState() => DraggableScrollableState();
}

class DraggableScrollableState extends State<DraggableScrollable> {
  Future<List<Lights>> getLights() async {
    ListLights listLights = ListLights();
    List<Lights> lights = await listLights.getLights(context);
    lights.forEach((element) {
      Listing.add(LightsGrids(
          id: element.id, name: element.name, socket: widget.socket));
    });
    setState(() {});
    return lights;
  }

  @override
  void initState() {
    super.initState();
    getLights();
  }

  @override
  void dispose() {
    super.dispose();
    widget.socket.disconnect();
  }

  List<Widget> Listing = [
    const SizedBox(
      height: 50,
      child: Center(
          child: Text(
        "All Lights",
        style: TextStyle(fontSize: 20, color: Colors.white),
      )),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.08,
        minChildSize: 0.08,
        maxChildSize: 1,
        snapSizes: [0.5, 1],
        snap: true,
        builder: (BuildContext context, scrollSheetController) {
          return Card(
            color: CustomColours.transGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              controller: scrollSheetController,
              itemCount: Listing.length,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Listing[index],
                );
              },
            ),
          );
        });
  }
}
