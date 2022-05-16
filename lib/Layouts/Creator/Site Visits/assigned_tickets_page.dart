import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/summary_provider.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../Widgets/appBar.dart';
import '../../../Widgets/assigned_ticket_gridview_widget.dart';
import '../../../Widgets/logout_widget.dart';
import '../../../Widgets/navigation_bar_item.dart';
import '../../../Widgets/web_layout.dart';

class AssignedTikcketsPage extends StatefulWidget {
  const AssignedTikcketsPage({Key? key}) : super(key: key);

  @override
  _AssignedTikcketsPageState createState() => _AssignedTikcketsPageState();
}

class _AssignedTikcketsPageState extends State<AssignedTikcketsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
            ? CustomeAppBar(
                title: Text(
                  getTranselted(context, STA_ASSIGNED)!,
                  style: APPBAR_TEXT_STYLE,
                ),
              )
            : null,
        body: WebLayout(
          navItem: [
            NavigationBarItem(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, creatorHomeRoute, (route) {
                ModalRoute.withName(creatorHomeRoute);
                return false;
              }),
              text: getTranselted(context, HOME_PAGE_TITLE)!,
            ),
            NavigationBarItem(
              onTap: () => Navigator.pushNamed(context, creatorDashBoardRoute),
              text: 'Dashboard',
            ),
            NavigationBarItem(
              onTap: () {},
              text: getTranselted(context, TODAY_TICKETS)!,
            ),
            NavigationBarItem(
              onTap: () {},
              text: getTranselted(context, CUSTOMER_MGMT)!,
            ),
            NavigationBarItem(
              onTap: () {},
              text: getTranselted(context, SETTINGS)!,
            ),
            const LogoutWidget(),
          ],
          widget: AssignedTicketWidget(
            list: techs,
            routeName: creatorTechAssignedTicketRoute,
          ),
        ));
  }
}
