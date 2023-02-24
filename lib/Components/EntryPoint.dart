import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:synclights/Components/drawer_body.dart';
import 'package:synclights/utils/CoustomColours.dart';
import 'package:synclights/utils/CustomClaims.dart';

import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:http/http.dart' as http;

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key, required this.child});
  final Widget child;

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;
  bool admin = false;
  bool isMenuOpenInput = false;
  List placeList = [];
  TextEditingController controller = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400))
      ..addListener(
        () {
          setState(() {});
        },
      );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    CustomClaims().then((value) {
      try {
        admin = value["admin"] ?? false;
      } catch (e) {
        admin = false;
      }
      setState(() => {});
    });
    super.initState();
  }

  void getSuggestion(String input) async {
    String apiKey = "AIzaSyDQ2c_pOSOFYSjxGMwkFvCVWKjYOM9siow";
    String type = '(regions)';

    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=$apiKey&sessiontoken=1234567890&components=country:in&types=$type';
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          placeList = data["predictions"];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      // toastMessage('success');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColours.transGreen,
      body: Stack(
        children: [
          AnimatedPositioned(
            width: 288,
            height: MediaQuery.of(context).size.height,
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 0 : -288,
            top: 0,
            child: const DrawerBody(
              color: Colors.black,
            ),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(
                  1 * animation.value - 30 * (animation.value) * 3.14 / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                  scale: scalAnimation.value,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/background/Splash.png'),
                          fit: BoxFit.cover),
                    ),
                    child: child,
                  )),
            ),
          ),
          
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 220 : 0,
            top: 5,
            child: SafeArea(
              child: Row(children: [
                IconButton(
                  icon: Icon(
                    (isMenuOpenInput ? Icons.close : Icons.menu),
                    color: isMenuOpenInput ? Colors.white : CustomColours.green,
                  ),
                  onPressed: () {
                    setState(() {
                      isMenuOpenInput = !isMenuOpenInput;
                      isSideBarOpen = !isSideBarOpen;
                      if (isSideBarOpen) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                    });
                  },
                ),
                SizedBox(
                  width: width * 0.85,
                  child: SearchBarAnimation(
                    durationInMilliSeconds: 500,
                    buttonShadowColour: CustomColours.green,
                    isSearchBoxOnRightSide: true,
                    enableKeyboardFocus: true,
                    hintText: 'Search Location',
                    isOriginalAnimation: false,
                    buttonBorderColour: Colors.black45,
                    trailingWidget: const Icon(Icons.search),
                    buttonWidget: const Icon(Icons.search),
                    textEditingController: TextEditingController(),
                    secondaryButtonWidget: const Icon(Icons.close),
                    buttonElevation: 1,
                    onFieldSubmitted: (value) {
                      getSuggestion(value);
                    },
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
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
