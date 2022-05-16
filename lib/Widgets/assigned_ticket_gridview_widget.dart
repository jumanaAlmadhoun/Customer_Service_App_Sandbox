import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../Routes/route_names.dart';

class AssignedTicketWidget extends StatelessWidget {
  List list;
  String routeName;
  AssignedTicketWidget({Key? key, required this.list, required this.routeName})
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
      itemCount: list.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: ICONS_COLOR),
                borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: ListTile(
              leading: Text(list[i].name!),
              trailing: Text(
                list[i].assignedTickets!.length.toString(),
                style: const TextStyle(color: BACK_ICON_COLOR),
              ),
              onTap: () {
                Navigator.pushNamed(context, routeName, arguments: list[i]);
              },
            ),
          ),
        );
      },
    );
  }
}
