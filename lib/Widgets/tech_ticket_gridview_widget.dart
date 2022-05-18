// ignore_for_file: must_be_immutable
import 'package:customer_service_app/Widgets/teckt_ticket_number.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TeckTicketGridView extends StatelessWidget {
  List? list;
  String? routeName;
  TeckTicketGridView({Key? key, required this.list, required this.routeName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? 1
              : (ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
                      ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                  ? 3
                  : 4,
          childAspectRatio: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? 7
              : (ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
                      ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                  ? 2.5
                  : 3),
      itemCount: list!.length,
      itemBuilder: (context, i) {
        return list![i].name != null
            ? TeckTicketNumber(
                techName: list![i].name!,
                ticketsNumber: list![i].assignedTickets!.length.toString(),
                routeName: routeName,
                argument: list![i],
              )
            : Container();
      },
    );
  }
}
