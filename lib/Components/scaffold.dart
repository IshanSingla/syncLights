import 'package:flutter/material.dart';

void scaffold(text, context) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }