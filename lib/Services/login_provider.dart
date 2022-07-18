// ignore_for_file: constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

String? userName;
String? role;

class LoginHandeler with ChangeNotifier {
  static const String NAME = 'name';
  static const String PASSWORD = 'password';
  static const String PHONE_NUMBER = 'phone';
  static const String ROLE = 'role';
  static const String CREATOR = 'creator';
  static const String TECH = 'sanremoTech';
  static const String ACCOUNTING = 'accounting';
  static const String LOGISTIC = 'logistics';
  static const String ADMIN = 'admin';
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging fbm = FirebaseMessaging.instance;

  Future<void> loginUser(
      BuildContext context, String phone, String password) async {
    var response = await http.get(Uri.parse('$DB_URL$DB_USERS.json'));
    var data = jsonDecode(response.body) as Map<String, dynamic>;
    bool found = false;
    data.forEach((key, value) {
      if (value[PHONE_NUMBER] == phone && value[PASSWORD] == password) {
        found = true;
        userName = value[NAME];
        role = value[ROLE];
        print(userName);
      }
    });
    if (found) {
      var pref = await SharedPreferences.getInstance();
      if (pref.getString(PHONE_NUMBER) == null) {
        await pref.setString(PHONE_NUMBER, phone);
        await pref.setString(PASSWORD, password);
        await pref.setString(ROLE, role.toString());
        await pref.setString(NAME, userName.toString());
      }
      directUser(context, role.toString());
    }
  }

  Future<String> directUser(BuildContext context, String role) async {
    switch (role) {
      case CREATOR:
        Navigator.pushReplacementNamed(context, creatorHomeRoute);
        fbm.subscribeToTopic('userTickets');
        return Future.value('DONE');
      case TECH:
        Navigator.pushReplacementNamed(context, techHomeRoute);
        fbm.subscribeToTopic(userName!);
        return Future.value('DONE');
      case ADMIN:
        Navigator.pushReplacementNamed(context, adminHomeRoute);
        return Future.value('DONE');
      default:
        return Future.value('ERROR');
    }
  }

  Future<void> notification(String name) async {
    try {
      print(name);
      CollectionReference notification = _db.collection('notification');
      notification.add({'date': DateTime.now(), 'name': name});
    } catch (ex) {
      print(ex);
    }
  }
}
