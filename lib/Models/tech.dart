import 'package:customer_service_app/Models/ticket.dart';
import 'package:flutter/cupertino.dart';

class Tech with ChangeNotifier {
  Tech(
      {this.assignedTickets, this.name, this.queueTicket, this.totalClosedJob});
  String? name;
  Map<String, String>? totalClosedJob;
  List<Ticket>? assignedTickets;
  List<Ticket>? queueTicket;
}
