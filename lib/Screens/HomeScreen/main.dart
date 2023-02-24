import 'package:flutter/material.dart';
import 'package:synclights/Screens/HomeScreen/components/body.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:synclights/utils/CoustomColours.dart';
import 'package:synclights/utils/CustomClaims.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool admin = false;

  @override
  void initState() {
    super.initState();

    CustomClaims().then((value) {
      try {
        admin = value["admin"] ?? false;
      } catch (e) {
        admin = false;
      }
      setState(() => {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Body();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 50,
        title: const Text('Home'),
        backgroundColor: CustomColours.green,
      ),
      body: const Body(),
      // drawer: const MyDrawer(),
      floatingActionButton: admin
          ? SpeedDial(
              backgroundColor: CustomColours.green,
              activeBackgroundColor: CustomColours.yellow,
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                    child: const Icon(Icons.admin_panel_settings),
                    label: "Add Admin"),
                SpeedDialChild(
                    child: const Icon(Icons.add), label: "Add Circle"),
                SpeedDialChild(
                    child: const Icon(Icons.traffic_sharp),
                    label: "Add Lights"),
              ],
            )
          : null,
    );
  }
}
