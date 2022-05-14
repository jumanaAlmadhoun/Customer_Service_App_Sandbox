// ignore_for_file: constant_identifier_names

import 'package:customer_service_app/Models/ticket.dart';
import 'package:flutter/cupertino.dart';

class Machine with ChangeNotifier {
  static const String MACHINE_MODEL = 'appDescrption';
  static const String CUSTOMER_NUMBER = 'customerNumber';
  static const String SERIAL_NUMBER = 'serialNumber';
  static const String HISTORY = 'History';
  static const String WS_MACHINE_MODEL = 'machineModel';
  static const String WS_MACHINE_NUMBER = 'machineNumber';

  Machine(
      {this.history,
      this.machineBrand,
      this.machineModel,
      this.machineNumber,
      this.customerNumber,
      this.firebaseID,
      this.fromTable});

  String? machineModel;
  String? machineNumber;
  String? machineBrand;
  String? customerNumber;
  String? fromTable;
  String? firebaseID;
  List<Ticket>? history;
}
