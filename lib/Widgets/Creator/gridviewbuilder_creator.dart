// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../Helpers/global_vars.dart';
import '../../Helpers/scripts_constants.dart';
import '../../Routes/route_names.dart';
import '../../Services/ticket_provider.dart';
import '../open_ticket_widget.dart';
import 'custom_list_dialgo.dart';

class GridViewBuilderCreator extends StatelessWidget {
  List list;
  CustomListDialog? dialog;
  GridViewBuilderCreator({Key? key, required this.list, required this.dialog})
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
              ? 2
              : (ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
                      ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                  ? 1
                  : 1),
      itemCount: list.length,
      itemBuilder: (context, i) {
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) async {
            if (dialog != null) {
              Provider.of<TicketProvider>(context, listen: false)
                  .archiveTicket(list[i], dialog!.value)
                  .then((value) async {
                if (value == SC_SUCCESS_RESPONSE) {
                  list.remove(list[i]);
                } else {}
              });
            }
          },
          confirmDismiss: (direction) async {
            dialog = CustomListDialog(
              msg: 'Archive Ticket',
              items: archiveReasons,
            );
            return await showDialog(context: context, builder: (_) => dialog!);
          },
          child: OpenTicketWidget(
            cafeName: list[i].cafeName,
            city: list[i].city,
            customerMobile: list[i].customerMobile,
            customerName: list[i].customerName,
            date: list[i].creationDate,
            didContact: list[i].didContact,
            machineNumber: list[i].machineNumber,
            onTap: () {
              Navigator.pushNamed(context, sanremoEditTicketRoute,
                  arguments: list[i]);
            },
          ),
        );
      },
    );
  }
}
