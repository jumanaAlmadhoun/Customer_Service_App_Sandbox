// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:flutter/material.dart';

class OpenTicketWidget extends StatelessWidget {
  const OpenTicketWidget(
      {Key? key,
      this.cafeName,
      this.city,
      this.customerMobile,
      this.customerName,
      this.date,
      this.didContact,
      this.onTap,
      this.machineNumber,
      this.onLongTap})
      : super(key: key);

  final String? customerName;
  final String? customerMobile;
  final String? cafeName;
  final String? date;
  final String? city;
  final String? machineNumber;
  final bool? didContact;
  final onTap;
  final onLongTap;

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
              color: didContact! ? CONTACTED_COLOR : NOT_CONTACTED_COLOR),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getTranselted(context, LBL_CAFE)! + ': ' + cafeName!,
                textAlign: TextAlign.left,
                style: TICKET_TEXT_STYLE,
                maxLines: 2,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                getTranselted(context, LBL_NAME)! + ': ' + customerName!,
                textAlign: TextAlign.left,
                style: TICKET_TEXT_STYLE,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                getTranselted(context, LBL_MACHINE_NUMBER)! +
                    ': ' +
                    machineNumber!,
                textAlign: TextAlign.left,
                style: TICKET_TEXT_STYLE,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                getTranselted(context, LBL_PHONE)! + ': ' + customerMobile!,
                textAlign: TextAlign.left,
                style: TICKET_TEXT_STYLE,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                getTranselted(context, LBL_CITY)! + ': ' + city!,
                textAlign: TextAlign.left,
                style: TICKET_TEXT_STYLE,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                getTranselted(context, LBL_DATE)! + ': ' + date!,
                textAlign: TextAlign.left,
                style: TICKET_TEXT_STYLE,
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
      onTap: onTap,
      onLongPress: onLongTap,
    );
  }
}
