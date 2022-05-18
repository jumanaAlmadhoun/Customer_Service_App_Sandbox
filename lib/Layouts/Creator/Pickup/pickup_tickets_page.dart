// ignore_for_file: import_of_legacy_library_into_null_safe, unused_field

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/Delivery/delivery_open_ticket_widget.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../Widgets/logout_widget.dart';
import '../../../Widgets/navigation_bar_item.dart';
import '../../../Widgets/web_layout.dart';

class PickupTicketsPage extends StatefulWidget {
  const PickupTicketsPage({Key? key}) : super(key: key);

  @override
  _PickupTicketsPageState createState() => _PickupTicketsPageState();
}

class _PickupTicketsPageState extends State<PickupTicketsPage> with RouteAware {
  List<Ticket> _tickets = [];
  List<Ticket> _showedTickets = [];
  bool _isLoading = false;
  bool _search = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    super.didPush();
    setState(() {
      _isLoading = true;
    });
    Provider.of<TicketProvider>(context, listen: false)
        .fetchTickets(DB_PICKUP_TICKETS)
        .then((value) {
      setState(() {
        _isLoading = false;
        _tickets = Provider.of<TicketProvider>(context, listen: false).tickets;
        _showedTickets = _tickets;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
            ? AppBar(
                title: _search
                    ? TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: getTranselted(context, LBL_SEARCH)!,
                          hintStyle: const TextStyle(color: Colors.white),
                        ),
                      )
                    : Text(getTranselted(context, TIC_PICK_UP)!),
                actions: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _search = !_search;
                      });
                    },
                    icon: const Icon(Icons.search),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, creatorNewPickupTicketRoute);
                      },
                      icon: const Icon(Icons.add))
                ],
              )
            : null,
        floatingActionButton: ResponsiveWrapper.of(context).isLargerThan(TABLET)
            ? FloatingActionButton(
                onPressed: () =>
                    Navigator.pushNamed(context, creatorNewPickupTicketRoute),
                child: const Icon(Icons.add),
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
          widget: _isLoading
              ? const SpinKitRipple(
                  color: APP_BAR_COLOR,
                )
              : Column(
                  children: [
                    ResponsiveWrapper.of(context).isLargerThan(TABLET)
                        ? Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              alignment: Alignment.center,
                              height: size.height * 0.1,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90.0),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 51, 51, 51),
                                    blurRadius: 8.0,
                                    offset: Offset(0.0, 10.0),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        top: 50.0, bottom: 50.0),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: ICONS_COLOR,
                                      size: 35,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(90.0),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  onChanged: (value) {} //TODO: search results
                                  /*(value) {
                                setState(() {
                                  try {
                                    _showedTickets = _tickets
                                        .where((element) => element.searchText!
                                            .contains(value.toUpperCase()))
                                        .toList();
                                  } catch (ex) {
                                    print(ex);
                                  }
                                });
                              },*/
                                  ),
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _tickets.length,
                        itemBuilder: (context, i) {
                          return DeliveryTicketWidget(
                            cafeName: _tickets[i].cafeName,
                            city: _tickets[i].city,
                            customerMobile: _tickets[i].extraContactNumber,
                            customerName: _tickets[i].customerName,
                            date: _tickets[i].creationDate,
                            didContact: _tickets[i].didContact,
                            techName: _tickets[i].techName,
                            type: _tickets[i].subCategory,
                            deliveryType: _tickets[i].status,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, creatorEditPickupTicketRoute,
                                  arguments: _tickets[i]);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ));
  }
}
