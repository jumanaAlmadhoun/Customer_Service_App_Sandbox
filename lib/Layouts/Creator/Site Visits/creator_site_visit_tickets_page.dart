// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/summary_provider.dart';
import 'package:customer_service_app/Widgets/category_item.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../Widgets/action_button.dart';
import '../../../Widgets/appBar.dart';
import '../../../Widgets/expandable_floating_button.dart';
import '../../../Widgets/gridview_count_widget.dart';
import '../../../Widgets/logout_widget.dart';
import '../../../Widgets/navigation_bar_item.dart';
import '../../../Widgets/web_layout.dart';

class CreatorSiteVisitPage extends StatefulWidget {
  const CreatorSiteVisitPage({Key? key}) : super(key: key);

  @override
  _CreatorSiteVisitPageState createState() => _CreatorSiteVisitPageState();
}

class _CreatorSiteVisitPageState extends State<CreatorSiteVisitPage>
    with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    Provider.of<SummaryProvider>(context, listen: false).fetchSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
            ? CustomeAppBar(
                action: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, brandSelectionRoute);
                      },
                      icon: const Icon(Icons.add))
                ],
                title: Text(
                  getTranselted(context, TIC_SITE_VISIT)!,
                  style: APPBAR_TEXT_STYLE,
                ),
              )
            : null,
        floatingActionButton: ResponsiveWrapper.of(context).isLargerThan(TABLET)
            ? ExpandableFab(
                distance: 160,
                children: [
                  ActionButton(
                    image: IMG_LOGO_SIPRESSO,
                    onPressed: () {},
                  ),
                  ActionButton(
                    image: IMG_LOGO_CEADO,
                    onPressed: () {},
                  ),
                  ActionButton(
                    image: IMG_LOGO_PM,
                    onPressed: () {},
                  ),
                  ActionButton(
                    image: IMG_LOGO_SANREMO,
                    onPressed: () => Navigator.pushNamed(
                        context, sanremoNewTicketRoute,
                        arguments: TEMP_SANREMO),
                  ),
                ],
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
          widget: GridViewCountWidget(
            widgets: [
              CategoryItem(
                image: IMG_OPEN_TICKETS,
                title: getTranselted(context, STA_OPEN)!,
                number: openTickets,
                onTap: () {
                  Navigator.pushNamed(context, creatorOpenTicketsRoute);
                },
              ),
              CategoryItem(
                image: IMG_WAITING_TICKETS,
                title: getTranselted(context, STA_WAITING)!,
                number: readyToAssignTickets,
                onTap: () {
                  Navigator.pushNamed(
                      context, creatorReadyToAssignTicketsRoute);
                },
              ),
              CategoryItem(
                image: IMG_QUEUE_TICKETS,
                title: getTranselted(context, STA_QUEUE)!,
                number: queueTickets,
                onTap: () {
                  Navigator.pushNamed(context, creatorQueueTicketsRoute);
                },
              ),
              CategoryItem(
                image: IMG_ASSIGNED_TICKETS,
                title: getTranselted(context, STA_ASSIGNED)!,
                number: assignedTickets,
                onTap: () {
                  Navigator.pushNamed(context, creatorAssignedTicketRoute);
                },
              ),
              CategoryItem(
                image: IMG_PENDING_TICKETS,
                title: getTranselted(context, STA_PENDING)!,
                number: pendingTickets,
                onTap: () {
                  Navigator.pushNamed(context, creatorPendingTicketsRoute);
                },
              ),
              CategoryItem(
                image: IMG_WORKSHO_REPORT,
                title: getTranselted(context, STA_WORKSHOP)!,
                number: pendingTickets,
              ),
            ],
          ), /*LayoutBuilder(
          builder: (context, constraints) => GridView.count(
            crossAxisCount: constraints.maxWidth < mobileWidth
                ? 2
                : constraints.maxWidth > ipadWidth
                    ? 4
                    : 3,
            childAspectRatio: constraints.maxWidth < mobileWidth ? 0.99 : 1.0,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            children: [
              CategoryItem(
                image: IMG_OPEN_TICKETS,
                title: getTranselted(context, STA_OPEN)!,
                number: openTickets,
                onTap: () {
                  Navigator.pushNamed(context, creatorOpenTicketsRoute);
                },
              ),
              CategoryItem(
                image: IMG_WAITING_TICKETS,
                title: getTranselted(context, STA_WAITING)!,
                number: readyToAssignTickets,
                onTap: () {
                  Navigator.pushNamed(
                      context, creatorReadyToAssignTicketsRoute);
                },
              ),
              CategoryItem(
                image: IMG_QUEUE_TICKETS,
                title: getTranselted(context, STA_QUEUE)!,
                number: queueTickets,
                onTap: () {
                  Navigator.pushNamed(context, creatorQueueTicketsRoute);
                },
              ),
              CategoryItem(
                image: IMG_ASSIGNED_TICKETS,
                title: getTranselted(context, STA_ASSIGNED)!,
                number: assignedTickets,
                onTap: () {
                  Navigator.pushNamed(context, creatorAssignedTicketRoute);
                },
              ),
              CategoryItem(
                image: IMG_PENDING_TICKETS,
                title: getTranselted(context, STA_PENDING)!,
                number: pendingTickets,
              ),
              CategoryItem(
                image: IMG_WORKSHO_REPORT,
                title: getTranselted(context, STA_WORKSHOP)!,
                number: pendingTickets,
              ),
            ],
          ),*/
        ));
  }
}
