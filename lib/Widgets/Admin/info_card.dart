// ignore_for_file: use_key_in_widget_constructors

import 'package:customer_service_app/Config/size_config.dart';
import 'package:customer_service_app/Widgets/Admin/primary_text.dart';
import 'package:flutter/material.dart';

import '../../Helpers/layout_constants.dart';

class InfoCard extends StatelessWidget {
  final String? icon;
  final String? label;
  final String? amount;

  const InfoCard({this.icon, this.label, this.amount});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(right: 4, left: 4),
      child: Container(
        padding: const EdgeInsets.only(right: 5, left: 5),
        height: size.height * 0.15,
        /* constraints: BoxConstraints(
            minWidth: Responsive.isDesktop(context)
                ? 200
                : SizeConfig.screenWidth! / 2 - 40),
        padding: EdgeInsets.only(
            top: 20,
            bottom: 20,
            left: 20,
            right: Responsive.isMobile(context) ? 20 : 40),*/
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ICONS_COLOR, width: 2.0),
            color: Colors.white,
            boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 2)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 2,
            ),
            PrimaryText(
                text: label,
                color: const Color.fromARGB(255, 134, 133, 117),
                size: 16),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 2,
            ),
            PrimaryText(
              text: amount,
              size: 18,
              fontWeight: FontWeight.w700,
              color: BACK_ICON_COLOR,
            )
          ],
        ),
      ),
    );
  }
}
