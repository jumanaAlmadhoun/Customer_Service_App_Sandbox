// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Services/customer_provider.dart';
import 'package:customer_service_app/Services/machines_provider.dart';
import 'package:customer_service_app/Services/summary_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../Widgets/appBar.dart';
import '../../Widgets/gridview_count_widget.dart';
import '../../Widgets/navigation_bar_item.dart';
import '../../Widgets/web_layout.dart';
import '../../main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../Helpers/layout_constants.dart';
import '../../../Localization/localization_constants.dart';
import '../../../Routes/route_names.dart';
import '../../../Services/summary_provider.dart';
import '../../../Widgets/category_item.dart';
import '../../../Widgets/creator_nav_bar.dart';
import '../../../Widgets/logout_widget.dart';

class CreatorHomePage extends StatefulWidget {
  const CreatorHomePage({Key? key}) : super(key: key);

  @override
  _CreatorHomePageState createState() => _CreatorHomePageState();
}

List cities = [];

class _CreatorHomePageState extends State<CreatorHomePage> with RouteAware {
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('Repo/cities.json');
    cities = await json.decode(response) as List<dynamic>;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() async {
    print('Pushed');
    super.didPush();
    readJson();
    Provider.of<MachinesProvider>(context, listen: false).fetchMachines();
    Provider.of<CustomerProvider>(context, listen: false).fetchCustomers();
    Provider.of<SummaryProvider>(context).fetchSummary();
  }

  @override
  void didPopNext() {
    print('Poped');
    super.didPopNext();
    readJson();
    Provider.of<MachinesProvider>(context, listen: false).fetchMachines();
    Provider.of<CustomerProvider>(context, listen: false).fetchCustomers();
    Provider.of<SummaryProvider>(context, listen: false).fetchSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? CustomeAppBar(
              action: const [LogoutWidget()],
              title: Text(
                getTranselted(context, HOME_PAGE_TITLE)!,
                style: APPBAR_TEXT_STYLE,
              ),
            )
          : null,
      drawer: const CreatorDrawerWidget(),
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
            siteVisitTickets == -1
                ? const SpinKitDancingSquare(
                    color: APP_BAR_COLOR,
                  )
                : CategoryItem(
                    title: getTranselted(context, TIC_SITE_VISIT)!,
                    image: IMG_SITE_VISIT,
                    number: siteVisitTickets,
                    onTap: () {
                      Navigator.pushNamed(context, creatorSiteVisitRoute);
                    },
                  ),
            deliveryTickets == -1
                ? const SpinKitDancingSquare(
                    color: APP_BAR_COLOR,
                  )
                : CategoryItem(
                    title: getTranselted(context, TIC_DELIVERY)!,
                    image: IMG_DELIVERY,
                    number: deliveryTickets,
                    onTap: () {
                      Navigator.pushNamed(context, creatorDeliveryTicketsRoute);
                    },
                  ),
            // exchangeTickets == -1
            //     ? const SpinKitDancingSquare(
            //         color: APP_BAR_COLOR,
            //       )
            //     : CategoryItem(
            //         title: getTranselted(context, TIC_EXCHANGE)!,
            //         image: IMG_EXCHANGE,
            //         number: exchangeTickets,
            //       ),
            pickupTickets == -1
                ? const SpinKitDancingSquare(
                    color: APP_BAR_COLOR,
                  )
                : CategoryItem(
                    title: getTranselted(context, TIC_PICK_UP)!,
                    image: IMG_PICKUP,
                    number: pickupTickets,
                    onTap: () {
                      Navigator.pushNamed(context, creatorPickupTicketsRoute);
                    }),
            // CategoryItem(
            //   title: getTranselted(context, TIC_ACCOUNTING)!,
            //   image: IMG_ACCOUNTING,
            // ),
            CategoryItem(
              title: getTranselted(context, TIC_CUSTOMER_TICKETS)!,
              image: IMG_CLIENT_TICKETS,
            ),
          ],
        ),
      ),
    );
  }
}
