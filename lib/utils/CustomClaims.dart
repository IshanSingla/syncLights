// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

Future<Map<String, dynamic>> CustomClaims() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('user not logged in');
  } else {
    String token = await user!.getIdToken();
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    return payloadMap;
  }
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}
