import 'package:customer_service_app/Models/ticket.dart';
import 'package:flutter/cupertino.dart';

class Machine with ChangeNotifier {
  String? machineModel;
  String? machineNumber;
  String? machineColor;
  String? machineBrand;
  List<Ticket>? history;
}
