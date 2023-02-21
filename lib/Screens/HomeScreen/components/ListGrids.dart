// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class LastGrids extends StatefulWidget {
  final String name;
  final String id;

  const LastGrids({super.key, required this.name, required this.id});

  @override
  LastGridsState createState() => LastGridsState();
}

class LastGridsState extends State<LastGrids> {
  int red = 100;
  int yelew = 255;
  int green = 100;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Card(
      margin: const EdgeInsets.all(15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            height: 100,
            width: width * 1 / 7,
            child: Card(
              color: Colors.black,
              margin: const EdgeInsets.all(14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  Icon(Icons.circle, color: Color.fromARGB(red, 255, 0, 0)),
                  Icon(Icons.circle, color: Color.fromARGB(yelew, 255, 255, 0)),
                  Icon(Icons.circle, color: Color.fromARGB(green, 0, 255, 0))
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: width * 5 / 7,
            child: Column(
              children: [
                Labels(
                  keys: "Road Name: ",
                  value: widget.name,
                  color: Color.fromARGB(255, 255, 150, 0),
                ),
                Labels(
                  keys: "Status: ",
                  value: "InActive",
                  color: Colors.red,
                ),
                Labels(
                  keys: "Vahicle Count: ",
                  value: "None",
                  color: Colors.red,
                ),
                Labels(
                  keys: "Timer: ",
                  value: "None",
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Labels extends StatelessWidget {
  final String keys;
  final String value;
  final Color color;

  Labels({
    super.key,
    required this.keys,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Row(
        children: [
          Text(
            keys,
            style: TextStyle(fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 14),
          )
        ],
      ),
    );
  }
}

// Widget Labels(
//     {required String key,
//     required String value,
//     required Color color,
//     required double size}) {
//   return SizedBox(
//     width: 200,
//     child: Row(
//       children: [
//         Text(
//           key,
//           style: TextStyle(fontSize: 13),
//         ),
//         Text(
//           value,
//           style: TextStyle(color: color, fontSize: size),
//         )
//       ],
//     ),
//   );
// }
