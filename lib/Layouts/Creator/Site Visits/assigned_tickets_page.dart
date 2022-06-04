// ignore_for_file: unnecessary_null_comparison

import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/tech.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/summary_provider.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../Widgets/appBar.dart';
import '../../../Widgets/logout_widget.dart';
import '../../../Widgets/navigation_bar_item.dart';
import '../../../Widgets/teckt_ticket_number.dart';
import '../../../Widgets/web_layout.dart';

class AssignedTikcketsPage extends StatefulWidget {
  const AssignedTikcketsPage({Key? key}) : super(key: key);

  @override
  _AssignedTikcketsPageState createState() => _AssignedTikcketsPageState();
}

class _AssignedTikcketsPageState extends State<AssignedTikcketsPage>
    with RouteAware {
  List<Tech> _techs = [];
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    // TODO: implement didPush
    super.didPush();
    _techs = techs
        .where((element) =>
            element.assignedTickets != null &&
            element.assignedTickets!.isNotEmpty)
        .toList();
  }

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
          widget: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                        ? 1
                        : (ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
                                ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                            ? 3
                            : 4,
                childAspectRatio:
                    ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                        ? 7
                        : (ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
                                ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                            ? 2.5
                            : 3),
            itemCount: _techs.length,
            itemBuilder: (context, i) {
              return _techs[i].assignedTickets != null
                  ? TeckTicketNumber(
                      techName: _techs[i].name!,
                      ticketsNumber:
                          _techs[i].assignedTickets!.length.toString(),
                      routeName: creatorTechAssignedTicketRoute,
                      argument: _techs[i],
                    )
                  : Container(); /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Text(techs[i].name!),
                    trailing: Text(techs[i].assignedTickets!.length.toString()),
                    onTap: () {
                      Navigator.pushNamed(
                          context, creatorTechAssignedTicketRoute,
                          arguments: techs[i]);
                    },
                  ),
                ),
              );*/
            },
          ), /*TeckTicketGridView(
                  list: techs,
                  routeName: creatorTechAssignedTicketRoute,
                ),*/
        ));
  }
}
