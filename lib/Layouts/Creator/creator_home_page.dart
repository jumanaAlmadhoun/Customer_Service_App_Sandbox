// ignore_for_file: avoid_print, import_of_legacy_library_into_null_safe

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
import '../../Widgets/navigation_bar_item.dart';
import '../../Widgets/web_layout.dart';
import '../../main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../Helpers/layout_constants.dart';
import '../../../Localization/localization_constants.dart';
import '../../../Routes/route_names.dart';
import '../../../Services/summary_provider.dart';
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
    double _width = MediaQuery.of(context).size.width;
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
        widget: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    siteVisitTickets == -1
                        ? const SpinKitDancingSquare(
                            color: ICON_TEX_COLOR,
                          )
                        :
                        // : CategoryItem(
                        //     title: getTranselted(context, TIC_SITE_VISIT)!,
                        //     image: IMG_SITE_VISIT,
                        //     number: siteVisitTickets,
                        //     onTap: () {
                        //       Navigator.pushNamed(context, creatorSiteVisitRoute);
                        //     },
                        //   ),
                        _cardGroup(
                            _width / 2.2,
                            200,
                            getTranselted(context, TIC_SITE_VISIT)!,
                            siteVisitTickets.toString(),
                            IMG_SITE_VISIT, () {
                            print('site');
                            Navigator.pushNamed(context, creatorSiteVisitRoute);
                          }),
                    const SizedBox(
                      height: 10,
                    ),
                    deliveryTickets == -1
                        ? const SpinKitDancingSquare(
                            color: ICON_TEX_COLOR,
                          )
                        // : CategoryItem(
                        //     title: getTranselted(context, TIC_DELIVERY)!,
                        //     image: IMG_DELIVERY,
                        //     number: deliveryTickets,
                        //     onTap: () {
                        //       Navigator.pushNamed(context, creatorDeliveryTicketsRoute);
                        //     },
                        //   ),
                        : _cardGroup(
                            _width / 2.2,
                            260,
                            getTranselted(context, TIC_DELIVERY)!,
                            deliveryTickets.toString(),
                            IMG_DELIVERY, () {
                            Navigator.pushNamed(
                                context, creatorDeliveryTicketsRoute);
                          }),
                    const SizedBox(
                      height: 10,
                    ),
                    // customerCompTickets == -1
                    //     ? const SpinKitDancingSquare(
                    //         color: ICON_TEX_COLOR,
                    //       )
                    //     // : CategoryItem(
                    //     //     title: getTranselted(context, TIC_DELIVERY)!,
                    //     //     image: IMG_DELIVERY,
                    //     //     number: deliveryTickets,
                    //     //     onTap: () {
                    //     //       Navigator.pushNamed(context, creatorDeliveryTicketsRoute);
                    //     //     },
                    //     //   ),
                    //     : _cardGroup(
                    //         _width / 2.2,
                    //         200,
                    //         getTranselted(context, TIC_CUSTOMER_COMP_TICKETS)!,
                    //         customerCompTickets.toString(),
                    //         IMG_CUSTOMER_COMP, () {

                    //       }),
                  ]),
                  const Spacer(),
                  Column(children: [
                    pickupTickets == -1
                        ? const SpinKitDancingSquare(
                            color: ICON_TEX_COLOR,
                          )
                        :
                        // : CategoryItem(
                        //     title: getTranselted(context, TIC_SITE_VISIT)!,
                        //     image: IMG_SITE_VISIT,
                        //     number: siteVisitTickets,
                        //     onTap: () {
                        //       Navigator.pushNamed(context, creatorSiteVisitRoute);
                        //     },
                        //   ),
                        _cardGroup(
                            _width / 2.2,
                            250,
                            getTranselted(context, TIC_PICK_UP)!,
                            pickupTickets.toString(),
                            IMG_PICKUP, () {
                            Navigator.pushNamed(
                                context, creatorPickupTicketsRoute);
                          }),
                    const SizedBox(
                      height: 10,
                    ),
                    customerTickets == -1
                        ? const SpinKitDancingSquare(
                            color: ICON_TEX_COLOR,
                          )
                        // : CategoryItem(
                        //     title: getTranselted(context, TIC_DELIVERY)!,
                        //     image: IMG_DELIVERY,
                        //     number: deliveryTickets,
                        //     onTap: () {
                        //       Navigator.pushNamed(context, creatorDeliveryTicketsRoute);
                        //     },
                        //   ),
                        : _cardGroup(
                            _width / 2.2,
                            200,
                            getTranselted(context, TIC_CUSTOMER_TICKETS)!,
                            customerTickets.toString(),
                            IMG_CLIENT_TICKETS, () {
                            Navigator.pushNamed(
                                context, creatorCustomerTicketsRoute);
                          }),
                  ]),
                  // exchangeTickets == -1
                  //     ? const SpinKitDancingSquare(
                  //         color: APP_BAR_COLOR,
                  //       )
                  //     : CategoryItem(
                  //         title: getTranselted(context, TIC_EXCHANGE)!,
                  //         image: IMG_EXCHANGE,
                  //         number: exchangeTickets,
                  //       ),
                  // pickupTickets == -1
                  //     ? const SpinKitDancingSquare(
                  //         color: APP_BAR_COLOR,
                  //       )
                  //     : CategoryItem(
                  //         title: getTranselted(context, TIC_PICK_UP)!,
                  //         image: IMG_PICKUP,
                  //         number: pickupTickets,
                  //         onTap: () {
                  //           Navigator.pushNamed(
                  //               context, creatorPickupTicketsRoute);
                  //         }),
                  // // CategoryItem(
                  // //   title: getTranselted(context, TIC_ACCOUNTING)!,
                  // //   image: IMG_ACCOUNTING,
                  // // ),
                  // CategoryItem(
                  //   title: getTranselted(context, TIC_CUSTOMER_TICKETS)!,
                  //   image: IMG_CLIENT_TICKETS,
                  // ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _cardGroup(double _width, double _height, String _title,
      String _person, String _image, onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  _image,
                ),
                fit: BoxFit.cover),
            borderRadius: const BorderRadius.all(Radius.circular(15.0))),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 10.0,
              bottom: 10.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                        shadows: [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: 4.0,
                              spreadRadius: 10.0)
                        ]),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            _person + " Ticket",
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "Sofia",
                                fontWeight: FontWeight.w700,
                                shadows: [
                                  BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 4.0,
                                      spreadRadius: 10.0)
                                ]),
                          ),
                          const SizedBox(
                            width: 3.0,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
