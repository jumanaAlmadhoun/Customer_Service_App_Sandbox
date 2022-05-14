// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';

class RfaMachine with ChangeNotifier {
  static const String MACHINE_CODE = 'machineCode';
  static const String SERIAL_NUMBER = 'serialNumber';
  static const String MACHINE_MODEL = 'machineModel';
  static const String LOCATION = 'location';
  static const String STATUS = 'status';
  static const String COLOR = 'color';

  RfaMachine(
      {this.color,
      this.location,
      this.machineCode,
      this.machineModel,
      this.serialNumber,
      this.status});

  String? machineCode;
  String? serialNumber;
  String? machineModel;
  String? color;
  String? location;
  String? status;
}
