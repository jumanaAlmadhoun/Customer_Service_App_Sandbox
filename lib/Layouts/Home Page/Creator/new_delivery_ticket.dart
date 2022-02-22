import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:flutter/material.dart';

class NewDeliveryTicket extends StatefulWidget {
  const NewDeliveryTicket({Key? key}) : super(key: key);

  @override
  _NewDeliveryTicketState createState() => _NewDeliveryTicketState();
}

class _NewDeliveryTicketState extends State<NewDeliveryTicket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getTranselted(context, TIC_DELIVERY)!)),
    );
  }
}
