import 'package:cool_alert/cool_alert.dart';
import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/scripts_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/tech.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/open_ticket_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class TechQueueTicketPage extends StatefulWidget {
  TechQueueTicketPage(this.tech);
  final Tech? tech;

  @override
  State<TechQueueTicketPage> createState() => _TechQueueTicketPageState();
}

class _TechQueueTicketPageState extends State<TechQueueTicketPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tech!.name!)),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: ListView.builder(
          itemCount: widget.tech!.queueTicket!.length,
          itemBuilder: (context, i) {
            try {
              return PopupMenuButton(
                itemBuilder: ((context) => [
                      PopupMenuItem(
                        child:
                            Text(getTranselted(context, STA_QUEUE_GET_BACK)!),
                        value: 'Back',
                      ),
                      PopupMenuItem(
                        child: Text(getTranselted(context, STA_QUEUE_ASSIGN)!),
                        value: 'Send',
                      ),
                    ]),
                onSelected: (String? value) async {
                  setState(() {
                    _isLoading = true;
                  });
                  if (value == 'Back') {
                    setState(() {
                      _isLoading = true;
                    });
                    Provider.of<TicketProvider>(context, listen: false)
                        .getBackQueueTicket(widget.tech!.queueTicket![i],
                            '$DB_URL$DB_QUEUE_TICKETS/${widget.tech!.name}/${widget.tech!.queueTicket![i].firebaseID}.json')
                        .then((value) {
                      if (value == SC_SUCCESS_RESPONSE) {
                        setState(() {
                          widget.tech!.queueTicket!.removeAt(i);
                          _isLoading = false;
                        });
                      }
                    });
                  } else if (value == 'Send') {
                    setState(() {
                      _isLoading = true;
                    });
                    Provider.of<TicketProvider>(context, listen: false)
                        .sendTicketFromQueue(
                            '$DB_URL$DB_QUEUE_TICKETS/${widget.tech!.name}/${widget.tech!.queueTicket![i].firebaseID}.json')
                        .then((value) {
                      setState(() {
                        _isLoading = false;
                      });
                      if (value == SC_SUCCESS_RESPONSE) {
                        setState(() {
                          widget.tech!.queueTicket!.removeAt(i);
                          _isLoading = false;
                        });
                      }
                    });
                  }
                },
                child: OpenTicketWidget(
                  cafeName: widget.tech!.queueTicket![i].cafeName,
                  city: widget.tech!.queueTicket![i].city,
                  customerMobile:
                      widget.tech!.queueTicket![i].extraContactNumber,
                  customerName: widget.tech!.queueTicket![i].customerName,
                  date: widget.tech!.queueTicket![i].creationDate,
                  didContact: widget.tech!.queueTicket![i].didContact,
                  machineNumber: widget.tech!.queueTicket![i].machineNumber,
                ),
              );
            } catch (ex) {
              print(ex);
              return Container();
            }
          },
        ),
      ),
    );
  }
}
