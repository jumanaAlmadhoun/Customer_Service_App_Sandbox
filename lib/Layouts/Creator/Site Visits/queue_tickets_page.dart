import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/tech.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/summary_provider.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../Helpers/layout_constants.dart';
import '../../../Widgets/appBar.dart';
import '../../../Widgets/logout_widget.dart';
import '../../../Widgets/navigation_bar_item.dart';
import '../../../Widgets/teckt_ticket_number.dart';
import '../../../Widgets/web_layout.dart';

class QueueTikcketsPage extends StatefulWidget {
  const QueueTikcketsPage({Key? key}) : super(key: key);

  @override
  _QueueTikcketsPageState createState() => _QueueTikcketsPageState();
}

class _QueueTikcketsPageState extends State<QueueTikcketsPage> with RouteAware {
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
            element.queueTicket != null && element.queueTicket!.isNotEmpty)
        .toList();
    print(_techs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? CustomeAppBar(
              action: const [LogoutWidget()],
              title: Text(
                getTranselted(context, STA_QUEUE)!,
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
                  crossAxisCount: ResponsiveWrapper.of(context)
                          .isSmallerThan(TABLET)
                      ? 1
                      : (ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
                              ResponsiveWrapper.of(context)
                                  .isSmallerThan(DESKTOP))
                          ? 3
                          : 4,
                  childAspectRatio: ResponsiveWrapper.of(context)
                          .isSmallerThan(TABLET)
                      ? 7
                      : (ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
                              ResponsiveWrapper.of(context)
                                  .isSmallerThan(DESKTOP))
                          ? 2.5
                          : 3),
              itemCount: _techs.length,
              itemBuilder: (context, i) {
                return _techs[i].queueTicket != null
                    ? TeckTicketNumber(
                        techName: _techs[i].name!,
                        ticketsNumber: _techs[i].queueTicket!.length.toString(),
                        routeName: creatorTechQueueTicketRoute,
                        argument: _techs[i],
                      )
                    /*  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Text(techs[i].name!),
                              trailing:
                                  Text(techs[i].queueTicket!.length.toString()),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, creatorTechQueueTicketRoute,
                                    arguments: techs[i]);
                              },
                            )),
                      )*/
                    : Container();
              }) /*TeckTicketGridView(
          list: techs,
          routeName: creatorTechQueueTicketRoute,
        ),*/
          ),
    );
  }
}
