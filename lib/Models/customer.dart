import 'package:customer_service_app/Models/ticket.dart';
import 'package:flutter/cupertino.dart';

class Customer with ChangeNotifier {
  String? customerNumber;
  String? customerName;
  String? companyName;
  String? mobile;
  double? balance;
  List<Ticket>? history;
  Map<String, dynamic>? contacts;
}
