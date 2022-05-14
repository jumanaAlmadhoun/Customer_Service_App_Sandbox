// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Models/rfa_machine.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

int totalRfaMachines = -1;

class RfaMachinesProvider with ChangeNotifier {
  List<RfaMachine> _machines = [];

  Future<void> fetchRfaMachines() async {
    totalRfaMachines = -1;
    try {
      _machines.clear();
      var response = await http.get(Uri.parse('$DB_URL$DB_RFA_MACHINES.json'));
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      List<RfaMachine> machines = [];
      totalRfaMachines = data.length;
      data.forEach((key, value) {
        machines.add(RfaMachine(
            color: value[RfaMachine.COLOR] ?? '',
            location: value[RfaMachine.LOCATION] ?? '',
            machineCode: value[RfaMachine.MACHINE_CODE] ?? '',
            machineModel: value[RfaMachine.MACHINE_MODEL] ?? '',
            status: value[RfaMachine.STATUS] ?? '',
            serialNumber: value[RfaMachine.SERIAL_NUMBER] ?? ''));
      });
      _machines = machines;
      notifyListeners();
    } catch (ex) {
      print(ex);
    }
  }

  List<RfaMachine> get machines {
    return [..._machines];
  }
}
