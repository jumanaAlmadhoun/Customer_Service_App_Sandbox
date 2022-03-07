import 'package:customer_service_app/Models/tech.dart';
import 'package:customer_service_app/Widgets/open_ticket_widget.dart';
import 'package:flutter/material.dart';

class TechAssignedTicketPage extends StatelessWidget {
  TechAssignedTicketPage(this.tech);
  final Tech? tech;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tech!.name!)),
      body: ListView.builder(
        itemCount: tech!.assignedTickets!.length,
        itemBuilder: (context, i) {
          return OpenTicketWidget(
            cafeName: tech!.assignedTickets![i].cafeName,
            city: tech!.assignedTickets![i].city,
            customerMobile: tech!.assignedTickets![i].extraContactNumber,
            customerName: tech!.assignedTickets![i].customerName,
            date: tech!.assignedTickets![i].creationDate,
            didContact: tech!.assignedTickets![i].didContact,
          );
        },
      ),
    );
  }
}
