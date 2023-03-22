// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:synclights/Components/scaffold.dart';
import 'package:synclights/Screens/HomeScreen/components/DraggableScrollable.dart';
import 'package:synclights/data/lights.dart';
import 'package:synclights/utils/CoustomColours.dart';
import 'package:synclights/utils/CustomClaims.dart';
import 'package:synclights/utils/converter.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);
  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  final textController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polylines = {
    Polyline(
      polylineId: const PolylineId("Route"),
      points: [],
      color: CustomColours.green,
      width: 5,
    )
  };
  bool condition = false;
  late final BitmapDescriptor ambulanceicon;
  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      scaffold(error.toString(), context);
    });
    return await Geolocator.getCurrentPosition();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.7333, 76.7794),
    zoom: 10,
  );

  @override
  void initState() {
    super.initState();
    fetch();
    _getUserCurrentLocation().then((value) async {
      final GoogleMapController controller = await _controller.future;

      CameraPosition kGooglePlex = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 13,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
      setState(() {});
    });
  }

  fetch() async {
    ListLights listLights = ListLights();
    List<Lights> lights = await listLights.getLights(context);
    ambulanceicon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/ambulance.png", 70));
    _markers.add(Marker(
      markerId: const MarkerId("User"),
      position: const LatLng(30.523982362724837, 76.66729521006346),
      icon: ambulanceicon,
    ));
    BitmapDescriptor markerbitmap = BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/light.png", 100));
    for (Lights element in lights) {
      _markers.add(Marker(
          markerId: MarkerId(element.id),
          position: element.codinates,
          icon: markerbitmap));
      _polylines.elementAt(0).points.add(element.codinates);
    }
    _polylines.elementAt(0).points.add(const LatLng(30.6833457, 76.851791));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onTap: (argument) async {
              bool admin;
              CustomClaims().then((value) {
                try {
                  admin = value["admin"] ?? false;
                } catch (e) {
                  admin = false;
                }
                if (admin) {
                  List<Map<String, String>> list = [
                    {"name": "Select Road Circle", "id": ""}
                  ];
                  FirebaseFirestore firestore = FirebaseFirestore.instance;
                  CollectionReference lights =
                      firestore.collection('roadCircles');
                  lights.get().then((value) {
                    for (var element in value.docs) {
                      list.add({
                        "name": element["circleName"],
                        "id": element.id,
                      });
                    }
                  }).then((value) {
                    Object value = list[0];
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Enter Light Name"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: textController,
                              ),
                              DropdownButton(
                                value: value,
                                items: list.map((Map items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items["name"]),
                                  );
                                }).toList(),
                                onChanged: (Object? newValue) {
                                  setState(() {
                                    value = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('CANCEL'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                FirebaseFirestore firestore =
                                    FirebaseFirestore.instance;
                                CollectionReference lights =
                                    firestore.collection('trafficLights');
                                lights.add({
                                  "signalLocation": {
                                    "lat": argument.latitude,
                                    "log": argument.longitude,
                                  },
                                  "signalName": textController.text,
                                  "roadCircle":
                                      (value as Map<String, String>)["id"]
                                }).then((value) {
                                  scaffold("Added SucessFully", context);
                                  Navigator.pop(context);
                                }).onError((error, stackTrace) {
                                  scaffold(error.toString(), context);
                                  Navigator.pop(context);
                                });
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  });
                }
              }).onError((error, stackTrace) {
                scaffold(error.toString(), context);
              });
            },
            trafficEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: condition ? _polylines : {},
            markers: {
              ..._markers,
              Marker(
                visible: condition,
                markerId: const MarkerId("hospital"),
                position: const LatLng(30.6833457, 76.851791),
              )
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Container(
            alignment: Alignment.centerRight,
            height: double.infinity,
            width: double.infinity,
            child: TextButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () {
                setState(() {
                  condition = !condition;
                });
              },
              icon: Image.asset('assets/ambulance.png', height: 50),
              label: const Text(''),
            ),
          ),
          DraggableScrollable()
        ],
      ),
    );
  }
}
