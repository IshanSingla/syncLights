import 'package:flutter/material.dart';
import 'package:synclights/Components/drawer.dart';
import 'package:synclights/Screens/HomeScreen/components/body.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:synclights/utils/CoustomColours.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: CustomColours.green,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: const Body(),
      drawer: const MyDrawer(),
      floatingActionButton: SpeedDial(
        backgroundColor: CustomColours.green,
        activeBackgroundColor: CustomColours.yellow,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.admin_panel_settings),
              label: "Add Admin"),
          SpeedDialChild(child: const Icon(Icons.add), label: "Add Circle"),
          SpeedDialChild(
              child: const Icon(Icons.traffic_sharp), label: "Add Lights"),
        ],
      ),
    );
  }
}
