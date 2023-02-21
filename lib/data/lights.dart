import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synclights/Components/scaffold.dart';

class Lights {
  double lat;
  double lon;
  String name;
  String id;
  Lights(
      {required this.lat,
      required this.lon,
      required this.name,
      required this.id});
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
        lightsList.add(Lights(
            lat: 0, lon: 0, name: data["signalName"] as String, id: element.id));
      }
      return lightsList;
    } catch (e) {
      scaffold(e.toString(), context);
      return [];
    }
  }
}
