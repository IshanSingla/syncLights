// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:synclights/Components/scaffold.dart';
import 'package:synclights/data/lights.dart';

class DraggableScrollable extends StatefulWidget {
  const DraggableScrollable({super.key});

  @override
  _DraggableScrollableState createState() => _DraggableScrollableState();
}

class _DraggableScrollableState extends State<DraggableScrollable> {
  Future<List<Lights>> getLights() async {
    ListLights listLights = ListLights();
    List<Lights> lights = await listLights.getLights(context);
    for (var i = 0; i < lights.length; i++) {
      Listing.add(
        SizedBox(
          height: 30,
          child: Center(
              child: Text(
            lights[i].name,
            style: TextStyle(fontSize: 20),
          )),
        ),
      );
    }
    setState(() {});
    return lights;
  }

  @override
  void initState() {
    super.initState();
    getLights();
  }

  var Listing = [
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
        initialChildSize: 0.07,
        minChildSize: 0.07,
        maxChildSize: 1,
        snapSizes: [0.5, 1],
        snap: true,
        builder: (BuildContext context, scrollSheetController) {
          return Container(
            color: Color.fromARGB(70, 0, 0, 0),
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
