import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:flutter/material.dart';

class TicketDownloadPage extends StatefulWidget {
  TicketDownloadPage(this.ticket, {Key? key}) : super(key: key);
  Ticket? ticket;
  @override
  State<TicketDownloadPage> createState() => _TicketDownloadPageState();
}

class _TicketDownloadPageState extends State<TicketDownloadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تحميل التذكرة'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ButtonWidget(text: 'تحميل التقرير', onTap: () {}),
            ],
          )
        ],
      ),
    );
  }
}
