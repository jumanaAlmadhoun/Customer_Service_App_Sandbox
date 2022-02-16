import 'package:customer_service_app/Models/ticket.dart';
import 'package:flutter/cupertino.dart';

class Tech with ChangeNotifier {
  Tech({this.assignedTickets, this.name, this.queueTicket});
  String? name;
  List<Ticket>? assignedTickets;
  List<Ticket>? queueTicket;
}
