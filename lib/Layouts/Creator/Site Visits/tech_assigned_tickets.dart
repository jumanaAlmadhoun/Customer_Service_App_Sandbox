import 'package:customer_service_app/Models/tech.dart';
import 'package:customer_service_app/Widgets/open_ticket_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../Helpers/layout_constants.dart';
import '../../../Localization/localization_constants.dart';
import '../../../Routes/route_names.dart';
import '../../../Widgets/appBar.dart';
import '../../../Widgets/logout_widget.dart';
import '../../../Widgets/navigation_bar_item.dart';
import '../../../Widgets/web_layout.dart';

class TechAssignedTicketPage extends StatelessWidget {
  const TechAssignedTicketPage(this.tech, {Key? key}) : super(key: key);
  final Tech? tech;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
            ? CustomeAppBar(
                title: Text(
                  tech!.name!,
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
                        ? 2
                        : (ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
                                ResponsiveWrapper.of(context)
                                    .isSmallerThan(DESKTOP))
                            ? 1
                            : 1),
            itemCount: tech!.assignedTickets!.length,
            itemBuilder: (context, i) {
              return OpenTicketWidget(
                cafeName: tech!.assignedTickets![i].cafeName,
                city: tech!.assignedTickets![i].city,
                customerMobile: tech!.assignedTickets![i].extraContactNumber,
                customerName: tech!.assignedTickets![i].customerName,
                date: tech!.assignedTickets![i].creationDate,
                didContact: tech!.assignedTickets![i].didContact,
                machineNumber: tech!.assignedTickets![i].machineNumber,
              );
            },
          ),
        ));
  }
}
