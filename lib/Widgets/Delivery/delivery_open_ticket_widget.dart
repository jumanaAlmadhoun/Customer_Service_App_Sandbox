import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:flutter/material.dart';

class DeliveryTicketWidget extends StatelessWidget {
  DeliveryTicketWidget(
      {this.cafeName,
      this.city,
      this.customerMobile,
      this.customerName,
      this.date,
      this.didContact,
      this.onTap,
      this.techName,
      this.type,
      this.deliveryType});

  final String? customerName;
  final String? customerMobile;
  final String? cafeName;
  final String? date;
  final String? city;
  final String? techName;
  final String? type;
  final String? deliveryType;
  final bool? didContact;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: ICONS_COLOR, width: 3),
                borderRadius: BorderRadius.circular(15),
                color: didContact! ? CONTACTED_COLOR : NOT_CONTACTED_COLOR),
            child: Center(
              child: Wrap(
                spacing: 8,
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    getTranselted(context, LBL_CAFE)! + ': ' + cafeName!,
                    textAlign: TextAlign.left,
                    style: TICKET_TEXT_STYLE,
                  ),
                  Text(
                    getTranselted(context, LBL_NAME)! + ': ' + customerName!,
                    textAlign: TextAlign.left,
                    style: TICKET_TEXT_STYLE,
                  ),
                  Text(
                    getTranselted(context, LBL_PHONE)! + ': ' + customerMobile!,
                    textAlign: TextAlign.left,
                    style: TICKET_TEXT_STYLE,
                  ),
                  Text(
                    getTranselted(context, LBL_CITY)! + ': ' + city!,
                    textAlign: TextAlign.left,
                    style: TICKET_TEXT_STYLE,
                  ),
                  Text(
                    getTranselted(context, LBL_DATE)! + ': ' + date!,
                    textAlign: TextAlign.left,
                    style: TICKET_TEXT_STYLE,
                  ),
                  Text(
                    'Status: ' + deliveryType!,
                    textAlign: TextAlign.left,
                    style: TICKET_TEXT_STYLE,
                  ),
                  deliveryType == 'Tech'
                      ? Text(
                          getTranselted(context, LBL_TECH_NAME)! +
                              ': ' +
                              techName!,
                          textAlign: TextAlign.left,
                          style: TICKET_TEXT_STYLE,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
        onTap: onTap);
  }
}
