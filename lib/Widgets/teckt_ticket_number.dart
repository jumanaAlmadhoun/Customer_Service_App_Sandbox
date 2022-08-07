// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import '../Helpers/layout_constants.dart';
import '../Models/tech.dart';

class TechTicketNumber extends StatelessWidget {
  String? routeName;
  String? techName;
  String? ticketsNumber;
  Tech? argument;
  TechTicketNumber(
      {Key? key,
      required this.routeName,
      required this.techName,
      required this.ticketsNumber,
      this.argument})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: ICONS_COLOR),
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: ListTile(
          leading: Text(techName!),
          trailing: Text(
            ticketsNumber!,
            style: const TextStyle(color: BACK_ICON_COLOR),
          ),
          onTap: () {
            Navigator.pushNamed(context, routeName!, arguments: argument!);
          },
        ),
      ),
    );
  }
}
