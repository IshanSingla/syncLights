import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:synclights/Components/scaffold.dart';
import 'package:synclights/Screens/HomeScreen/components/DraggableScrollable.dart';
import 'package:synclights/data/lights.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  String address = '';
  final Completer<GoogleMapController> _controller = Completer();
  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      scaffold(error.toString(), context);
    });
    return await Geolocator.getCurrentPosition();
  }

  final List<Marker> _markers = <Marker>[];

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.7333, 76.7794),
    zoom: 10,
  );

  List<Marker> list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.6844, 73.0479),
        infoWindow: InfoWindow(title: 'some Info ')),
  ];

  @override
  void initState() {
    super.initState();
    // fetch();
    _getUserCurrentLocation().then((value) async {
      setPoint(value.latitude, value.longitude);
    });
  }

  fetch() async {
    ListLights listLights = ListLights();
    List<Lights> lights = await listLights.getLights(context);
    for (Lights element in lights) {
      // _markers.add(Marker(
      //     markerId: MarkerId(element.id),
      //     position: LatLng(element.lat, element.lon),
      //     infoWindow: InfoWindow(title: element.name)));
      setPoint(element.lat, element.lon);
    }
  }

  setPoint(double lat, double lon) async {
    final GoogleMapController controller = await _controller.future;

    CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(lat, lon),
      zoom: 13,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            markers: Set<Marker>.of(_markers),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          DraggableScrollable()
        ],
      ),
    );
  }
}
