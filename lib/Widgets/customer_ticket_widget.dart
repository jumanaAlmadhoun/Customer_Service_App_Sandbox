// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';

class CustomerTicketWidget extends StatefulWidget {
  const CustomerTicketWidget(
      {Key? key,
      this.cafeName,
      this.city,
      this.customerMobile,
      this.customerName,
      this.date,
      this.didContact,
      this.onTap,
      this.machineNumber,
      this.mobile,
      this.onLongTap,
      this.ticket})
      : super(key: key);

  final String? customerName;
  final String? customerMobile;
  final String? cafeName;
  final String? date;
  final String? city;
  final String? machineNumber;
  final bool? didContact;
  final String? mobile;
  final Ticket? ticket;
  final onTap;
  final onLongTap;

  @override
  State<CustomerTicketWidget> createState() => _CustomerTicketWidgetState();
}

class _CustomerTicketWidgetState extends State<CustomerTicketWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(color: ICONS_COLOR, width: 2),
              borderRadius: BorderRadius.circular(15),
              color: widget.ticket!.didContact!
                  ? CONTACTED_COLOR
                  : NOT_CONTACTED_COLOR),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              getTranselted(context, LBL_CAFE)! + ': ' + widget.cafeName!,
              textAlign: TextAlign.left,
              style: TICKET_TEXT_STYLE,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              getTranselted(context, LBL_NAME)! + ': ' + widget.customerName!,
              textAlign: TextAlign.left,
              style: TICKET_TEXT_STYLE,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              getTranselted(context, LBL_MACHINE_NUMBER)! +
                  ': ' +
                  widget.machineNumber!,
              textAlign: TextAlign.left,
              style: TICKET_TEXT_STYLE,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              getTranselted(context, LBL_PHONE)! +
                  ': ' +
                  widget.customerMobile!,
              textAlign: TextAlign.left,
              style: TICKET_TEXT_STYLE,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              getTranselted(context, LBL_CITY)! + ': ' + widget.city!,
              textAlign: TextAlign.left,
              style: TICKET_TEXT_STYLE,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              getTranselted(context, LBL_DATE)! + ': ' + widget.date!,
              textAlign: TextAlign.left,
              style: TICKET_TEXT_STYLE,
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  color: Colors.brown,
                  icon: Icon(Icons.phone),
                  onPressed: () async {
                    String url = 'tel:${widget.mobile}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                ),
                const Text(
                  'Contacted Customer ?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Checkbox(
                  value: widget.ticket!.didContact,
                  onChanged: (value) async {
                    setState(() {
                      widget.ticket!.didContact = value;
                    });
                    await patch(
                        Uri.parse(
                            '$DB_URL$DB_SITE_VISITS/$DB_CUSTOMER_TICKETS/${widget.ticket!.firebaseID}.json'),
                        body: jsonEncode({Ticket.DID_CONTACT: value}));
                  },
                ),
              ],
            ),
          ]),
        ),
      ),
      onTap: widget.onTap,
      onLongPress: widget.onLongTap,
    );
  }
}
