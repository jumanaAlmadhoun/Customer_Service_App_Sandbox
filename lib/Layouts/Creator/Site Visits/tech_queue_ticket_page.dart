import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/tech.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/open_ticket_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            return PopupMenuButton(
              itemBuilder: ((context) => [
                    PopupMenuItem(
                      child: Text(getTranselted(context, STA_QUEUE_GET_BACK)!),
                      value: 'Back',
                    ),
                    PopupMenuItem(
                      child: Text(getTranselted(context, STA_QUEUE_ASSIGN)!),
                      value: 'Send',
                    ),
                  ]),
              onSelected: (String? value) async {
                if (value == 'Back') {
                  // await Provider.of<TicketProvider>(context, listen: false)
                  //     .getBackQueueTicket(
                  //         '$DB_URL$DB_QUEUE_TICKETS/${tech!.name}/${tech!.queueTicket![i].firebaseID}.json');
                } else if (value == 'Send') {}
              },
              child: OpenTicketWidget(
                cafeName: tech!.queueTicket![i].cafeName,
                city: tech!.queueTicket![i].city,
                customerMobile: tech!.queueTicket![i].extraContactNumber,
                customerName: tech!.queueTicket![i].customerName,
                date: tech!.queueTicket![i].creationDate,
                didContact: tech!.queueTicket![i].didContact,
                onTap: () {},
              ),
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
