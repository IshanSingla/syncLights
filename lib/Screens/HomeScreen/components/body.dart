import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:synclights/Components/scaffold.dart';
import 'package:synclights/Screens/HomeScreen/components/DraggableScrollable.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
    _getUserCurrentLocation().then((value) async {
      setPoint(value.latitude, value.longitude);
    });
  }

  setPoint(double lat, double lon) async {
    final GoogleMapController controller = await _controller.future;

    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(lat, lon),
      zoom: 13,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
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
          const DraggableScrollable()
        ],
      ),
    );
  }
}
