import 'dart:convert';

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Models/machine.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class MachinesProvider with ChangeNotifier {
  List<Machine> _machines = [];
  List<String> _machinesModels = [];

  Future<void> fetchMachines() async {
    try {
      List<Machine> machines = [];
      var response = await http.get(Uri.parse('$DB_URL$DB_MACHINES.json'));
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      data.forEach((key, value) {
        machines.add(Machine(
            machineModel: value[Machine.MACHINE_MODEL],
            machineNumber: value[Machine.SERIAL_NUMBER],
            customerNumber: value[Machine.CUSTOMER_NUMBER]));
      });
      _machines = machines;
      notifyListeners();
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> fetchModels() async {
    try {
      List<String> models = [];
      var response =
          await http.get(Uri.parse('$DB_URL$DB_SANREMO_MACHINES.json'));
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      data.forEach((key, value) {
        models.add(value['machineModel']);
      });
      _machinesModels = models;
      notifyListeners();
    } catch (ex) {
      print(ex);
    }
  }

  List<Machine> get machines {
    return [..._machines];
  }

  List<String> get models {
    return [..._machinesModels];
  }
}
