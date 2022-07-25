import 'package:cool_alert/cool_alert.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Util/formatters.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:flutter/material.dart';

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
                onTap: () {
                  if (widget.ticket!.machineNumber!.trim().toUpperCase() ==
                      machineNumberController.text.trim().toUpperCase()) {
                    Navigator.pushReplacementNamed(
                        context, techFillSiteVisitRoute,
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
