import 'package:customer_service_app/Models/ticket.dart';
import 'package:flutter/cupertino.dart';

class Tech with ChangeNotifier {
  String? name;
  List<Ticket>? history;
}
