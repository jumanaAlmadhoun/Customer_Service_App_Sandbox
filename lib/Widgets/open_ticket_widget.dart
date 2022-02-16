import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Helpers/scripts_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:flutter/material.dart';

class OpenTicketWidget extends StatelessWidget {
  OpenTicketWidget(
      {this.cafeName,
      this.city,
      this.customerMobile,
      this.customerName,
      this.date,
      this.didContact,
      this.onTap});

  final String? customerName;
  final String? customerMobile;
  final String? cafeName;
  final String? date;
  final String? city;
  final bool? didContact;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: APP_BAR_COLOR, width: 1),
                borderRadius: BorderRadius.circular(15),
                color: didContact! ? CONTACTED_COLOR : NOT_CONTACTED_COLOR),
            child: Column(
              children: [
                Text(
                  getTranselted(context, LBL_CAFE)! + ': ' + cafeName!,
                  textAlign: TextAlign.left,
                  style: TICKET_TEXT_STYLE,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  getTranselted(context, LBL_NAME)! + ': ' + customerName!,
                  textAlign: TextAlign.left,
                  style: TICKET_TEXT_STYLE,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  getTranselted(context, LBL_PHONE)! + ': ' + customerMobile!,
                  textAlign: TextAlign.left,
                  style: TICKET_TEXT_STYLE,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  getTranselted(context, LBL_CITY)! + ': ' + city!,
                  textAlign: TextAlign.left,
                  style: TICKET_TEXT_STYLE,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  getTranselted(context, LBL_DATE)! + ': ' + date!,
                  textAlign: TextAlign.left,
                  style: TICKET_TEXT_STYLE,
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
        onTap: onTap);
  }
}
