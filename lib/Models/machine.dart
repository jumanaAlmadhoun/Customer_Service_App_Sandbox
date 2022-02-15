import 'package:customer_service_app/Models/ticket.dart';
import 'package:flutter/cupertino.dart';

class Machine with ChangeNotifier {
  static const String MACHINE_MODEL = 'appDescrption';
  static const String CUSTOMER_NUMBER = 'customerNumber';
  static const String SERIAL_NUMBER = 'serialNumber';
  static const String HISTORY = 'History';

  Machine(
      {this.history,
      this.machineBrand,
      this.machineModel,
      this.machineNumber,
      this.customerNumber});

  String? machineModel;
  String? machineNumber;
  String? machineBrand;
  String? customerNumber;
  List<Ticket>? history;
}
