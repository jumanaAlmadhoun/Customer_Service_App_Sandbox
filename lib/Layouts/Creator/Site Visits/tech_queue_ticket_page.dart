import 'package:customer_service_app/Models/tech.dart';
import 'package:customer_service_app/Widgets/open_ticket_widget.dart';
import 'package:flutter/material.dart';

class TechQueueTicketPage extends StatelessWidget {
  TechQueueTicketPage(this.tech);
  final Tech? tech;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tech!.name!)),
      body: ListView.builder(
        itemCount: tech!.queueTicket!.length,
        itemBuilder: (context, i) {
          try {
            return OpenTicketWidget(
              cafeName: tech!.queueTicket![i].cafeName,
              city: tech!.queueTicket![i].city,
              customerMobile: tech!.queueTicket![i].extraContactNumber,
              customerName: tech!.queueTicket![i].customerName,
              date: tech!.queueTicket![i].creationDate,
              didContact: tech!.queueTicket![i].didContact,
              onTap: () {},
            );
          } catch (ex) {
            print(ex);
            return Container();
          }
        },
      ),
    );
  }
}
