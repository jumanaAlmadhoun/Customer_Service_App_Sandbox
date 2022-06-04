// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Models/tech.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class TechProvider with ChangeNotifier {
  List<Tech> _techs = [];
  Future<void> fetchAll() async {
    try {
      _techs.clear();
      List<Tech> techs = [];
      String currDate = DateTime.now().toString().split(' ')[0];
      String currMonth = currDate.substring(0, 7);
      print(currMonth);
      var response = await http
          .get(Uri.parse('$DB_URL$DB_SITE_VISITS/$DB_CLOSED_TICKETS.json'));
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      data.forEach((key, value) {
        String techName = key;
        int totalDay = 0;
        int totalMonth = 0;
        var dates = value as Map<String, dynamic>;

        dates.forEach((key, value) {
          var jobs = value as Map<String, dynamic>;
          if (key.startsWith(currMonth)) {
            totalMonth += jobs.length;
            if (key == currDate) {
              totalDay = jobs.length;
            }
          }
        });
        if (totalMonth != 0) {
          techs.add(Tech(
              name: techName,
              currMonthClosed: totalMonth,
              currDayClose: totalDay));
        }
      });
      _techs = techs;
      notifyListeners();
    } catch (ex) {}
  }

  List<Tech> get techsReport {
    return [..._techs];
  }

  int get totalClosedPerDay {
    int totalClosed = 0;
    try {
      _techs.forEach((element) {
        totalClosed += element.currDayClose!;
      });
      return totalClosed;
    } catch (ex) {
      return 0;
    }
  }

  int get totalClosedPerMonth {
    int totalClosed = 0;
    try {
      _techs.forEach((element) {
        totalClosed += element.currMonthClosed!;
      });
      return totalClosed;
    } catch (ex) {
      return 0;
    }
  }
}
