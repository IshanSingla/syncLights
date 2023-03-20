// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:synclights/Components/scaffold.dart';
import 'package:synclights/Screens/HomeScreen/components/DraggableScrollable.dart';
import 'package:synclights/data/lights.dart';
import 'package:synclights/utils/CoustomColours.dart';
import 'package:synclights/utils/converter.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);
  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
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
  LatLng hospital = LatLng(30.6833457, 76.851791);

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
      position: LatLng(30.523982362724837, 76.66729521006346),
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
    _polylines.elementAt(0).points.add(hospital);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onTap: (argument) => print(argument),
            trafficEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: condition ? _polylines : {},
            markers: {
              ..._markers,
              Marker(
                visible: condition,
                markerId: const MarkerId("hospital"),
                position: hospital,
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
              label: Text(''),
            ),
          ),
          DraggableScrollable()
        ],
      ),
    );
  }
}
