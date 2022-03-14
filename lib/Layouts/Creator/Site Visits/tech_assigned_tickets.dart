import 'package:customer_service_app/Models/tech.dart';
import 'package:customer_service_app/Widgets/open_ticket_widget.dart';
import 'package:flutter/material.dart';

import '../../../Helpers/layout_constants.dart';

class TechAssignedTicketPage extends StatelessWidget {
  TechAssignedTicketPage(this.tech);
  final Tech? tech;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(tech!.name!)),
        body: LayoutBuilder(
          builder: (context, constraints) => GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraints.maxWidth < mobileWidth
                  ? 1
                  : constraints.maxWidth < ipadWidth
                      ? 2
                      : 3,
              childAspectRatio: constraints.maxWidth < mobileWidth
                  ? 2.5
                  : constraints.maxWidth < ipadWidth
                      ? 1.5
                      : 1.4,
            ),
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
        ));
  }
}
