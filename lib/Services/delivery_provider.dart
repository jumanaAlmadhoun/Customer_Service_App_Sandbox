import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeliveryProvider with ChangeNotifier {
  List<Ticket> _tickets = [];

  Future<void> fetchTickets(String from) async {
    try {
      List<Ticket> tickets = [];
      var response =
          await http.get(Uri.parse('$DB_URL$DB_DELIVERY_TICKETS.json'));
    } catch (ex) {
      print(ex);
    }
  }

  List<Ticket> get tickets {
    return [..._tickets];
  }
}
