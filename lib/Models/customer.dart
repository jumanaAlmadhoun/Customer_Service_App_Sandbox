import 'package:customer_service_app/Models/ticket.dart';
import 'package:flutter/cupertino.dart';

class Customer with ChangeNotifier {
  static const String BALANCE = 'balance';
  static const String BLOCKED = 'blocked';
  static const String CITY = 'city';
  static const String COMPANY_NAME = 'companyName';
  static const String CONTACT_NAME = 'contactName';
  static const String CUSTOMER_NUMBER = 'customerNumber';
  static const String MOBILE = 'mobile';
  static const String HISTORY = 'History';

  Customer(
      {this.balance,
      this.companyName,
      this.customerName,
      this.customerNumber,
      this.history,
      this.mobile});

  String? customerNumber;
  String? customerName;
  String? companyName;
  String? mobile;
  double? balance;
  List<Ticket>? history;
  // Map<String, dynamic>? contacts;
}
