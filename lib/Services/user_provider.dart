import 'dart:convert';

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  List<String> _techNames = [];

  Future<void> fetchTechs() async {
    try {
      var response = await http.get(Uri.parse('$DB_URL$DB_USERS.json'));
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      List<String> tech = [];
      data.forEach((key, value) {
        if (value[LoginHandeler.ROLE] == LoginHandeler.TECH) {
          tech.add(value[LoginHandeler.NAME]);
        }
      });
      tech.add('N/A');
      _techNames = tech;
      notifyListeners();
    } catch (ex) {
      print(ex);
    }
  }

  List<String> get techs {
    return [..._techNames];
  }
}
