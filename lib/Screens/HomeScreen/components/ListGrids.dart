// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LightsGrids extends StatefulWidget {
  final String name;
  final String id;
  final IO.Socket socket;

  LightsGrids(
      {super.key, required this.name, required this.id, required this.socket});

  @override
  LightsGridsState createState() => LightsGridsState();
}

class LightsGridsState extends State<LightsGrids> {
  int red = 100;
  int yelew = 100;
  int green = 100;
  Map data = {"list":[], "lights":{}};

  @override
  void initState() {
    super.initState();

    widget.socket.on("users", (msg) {
      data = json.decoder.convert(msg);
      if (data["list"].isNotEmpty && data["list"].contains(widget.id)) {
        if (data["lights"][widget.id]["red"]) {
          red = 255;
          green = 100;
        } else {
          green = 255;
          red = 100;
        }
        setState(() => {});
      } else {
        red = 100;
        green = 100;
        data = {};
        setState(() => {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    Color color = data.isEmpty ? Colors.red : Colors.green;
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
                  keys: "Road: ",
                  value: widget.name,
                  color: const Color.fromARGB(255, 255, 150, 0),
                ),
                Labels(
                  keys: "Status: ",
                  value: data.isEmpty ? "InActive" : "Active",
                  color: color,
                ),
                Labels(
                  keys: "Vehicle: ",
                  value: data.isEmpty
                      ? "None"
                      : '${data["lights"][widget.id]["count"]}',
                  color: color,
                ),
                Labels(
                  keys: "Timer: ",
                  value: data.isEmpty
                      ? "None"
                      : '${data["lights"][widget.id]["time"]} s',
                  color: color,
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
            style: const TextStyle(fontSize: 13),
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
