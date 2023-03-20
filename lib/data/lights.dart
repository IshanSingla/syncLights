import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:synclights/Components/scaffold.dart';

class Lights {
  LatLng codinates;

  String name;
  String id;
  Lights({required this.name, required this.codinates, required this.id});
}

class ListLights {
  List<Lights> lights = [];
  ListLights();
  Future<List<Lights>> getLights(BuildContext context) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference lights = firestore.collection('trafficLights');
      QuerySnapshot querySnapshot = await lights.get();
      List<Lights> lightsList = [];
      for (var element in querySnapshot.docs) {
        Map data = element.data() as Map;
        var light = Lights(
            codinates: LatLng(data["signalLocation"]?["lat"] ?? 0,
                data["signalLocation"]["log"] ?? 0),
            name: data["signalName"] as String,
            id: element.id);

        lightsList.add(light);
      }
      return lightsList;
    } catch (e) {
      scaffold(e.toString(), context);
      return [];
    }
  }
}
