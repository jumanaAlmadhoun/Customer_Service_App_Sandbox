import 'package:cool_alert/cool_alert.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Util/formatters.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Routes/route_names.dart';

class MachineNumberConfirmationPage extends StatefulWidget {
  MachineNumberConfirmationPage(this.ticket);
  Ticket? ticket;

  @override
  State<MachineNumberConfirmationPage> createState() =>
      _MachineNumberConfirmationPageState();
}

class _MachineNumberConfirmationPageState
    extends State<MachineNumberConfirmationPage> {
  TextEditingController machineNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'التحقق من رقم المكينة',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'الرجاء إدخال رقم المكينة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                controller: machineNumberController,
                inputFormatters: [UpperCaseFormatter()],
                decoration: InputDecoration(label: Text('رقم المكينة')),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ButtonWidget(
                text: 'التالي',
                onTap: () async {
                  String page = '';
                  if (widget.ticket!.machineNumber!.trim().toUpperCase() ==
                      machineNumberController.text.trim().toUpperCase()) {
                    await Provider.of<TicketProvider>(context, listen: false)
                        .startFillReport(widget.ticket);

                    /*if (widget.ticket!.machineModel!.contains("PM")) {
                      page = 'techFillTicketPagePM';
                    } else if (widget.ticket!.machineModel!.contains("Ceado") ||
                        (widget.ticket!.machineModel!.contains("Leon")) ||
                        (widget.ticket!.machineModel!.contains("Grinder"))) {
                      page = 'techFillTicketPageGrinde';
                    } else if (widget.ticket!.machineModel!.contains("Bunn")) {
                      page = 'techFillTicketPageBunn';
                    } else {
                      page = 'techFillSiteVisitRoute';
                    }*/

                    if (widget.ticket!.machineType!.trim() ==
                        ("Perfect Moose")) {
                      page = 'techFillTicketPagePM';
                    } else if (widget.ticket!.machineType!.trim() ==
                        "Coffee Grinders") {
                      page = 'techFillTicketPageGrinde';
                    } else if (widget.ticket!.machineType!.trim() ==
                        "Batch Brewer") {
                      page = 'techFillTicketPageBunn';
                    } else if (widget.ticket!.machineType!.trim() ==
                        "Espresso Machines") {
                      page = 'techFillSiteVisitRoute';
                    }

                    Navigator.pushReplacementNamed(context, page,
                        arguments: widget.ticket);
                  } else {
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        text: 'رقم المكينة غير مطابق للتقرير');
                  }
                })
          ],
        ),
      ),
    );
  }
}
