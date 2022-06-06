// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:customer_service_app/Config/size_config.dart';
import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/Admin/info_card.dart';
import 'package:customer_service_app/Widgets/Admin/primary_text.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CreatorDashBoard extends StatefulWidget {
  const CreatorDashBoard({Key? key}) : super(key: key);

  @override
  State<CreatorDashBoard> createState() => _CreatorDashBoardState();
}

class _CreatorDashBoardState extends State<CreatorDashBoard> with RouteAware {
  List<Ticket> allOpenTickets = [];
  List<Ticket> allDeliveryTickets = [];
  List<Ticket> allPickupTickets = [];
  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() async {
    super.didPush();
    setState(() {
      _isLoading = true;
    });
    await Provider.of<TicketProvider>(context, listen: false)
        .fetchTickets(DB_OPEN_TICKETS);
    allOpenTickets =
        Provider.of<TicketProvider>(context, listen: false).tickets;
    await Provider.of<TicketProvider>(context, listen: false)
        .fetchTickets(DB_DELIVERY_TICKETS);
    allDeliveryTickets =
        Provider.of<TicketProvider>(context, listen: false).tickets;
    await Provider.of<TicketProvider>(context, listen: false)
        .fetchTickets(DB_PICKUP_TICKETS);
    allPickupTickets =
        Provider.of<TicketProvider>(context, listen: false).tickets;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: _isLoading
          ? const SpinKitChasingDots(
              color: APP_BAR_COLOR,
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(children: [
                PrimaryText(
                  text: 'Late Tickets',
                )
              ]),
            ),
    );
  }
}
