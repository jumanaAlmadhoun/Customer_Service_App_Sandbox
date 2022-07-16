import 'dart:convert';

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Models/customer.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];

  Future<void> fetchCustomers() async {
    try {
      List<Customer> customers = [];
      List<Ticket> history = [];
      var response = await http.get(Uri.parse('$DB_URL$DB_CUSTOMERS.json'));
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      data.forEach((key, value) {
        customers.add(Customer(
            balance: double.parse(value[Customer.BALANCE] ?? '0'),
            companyName: value[Customer.COMPANY_NAME] ?? '',
            customerName: value[Customer.CONTACT_NAME] ?? '',
            customerNumber: value[Customer.CUSTOMER_NUMBER] ?? '',
            mobile: value[Customer.MOBILE] ?? '',
            blocked: value[Customer.BLOCKED] ?? ''));
      });
      _customers = customers;
      notifyListeners();
    } catch (ex) {
      print(ex);
    }
  }

  List<Customer> get customers {
    return [..._customers];
  }
}
