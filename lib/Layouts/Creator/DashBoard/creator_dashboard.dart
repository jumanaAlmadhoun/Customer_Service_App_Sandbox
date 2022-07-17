// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:customer_service_app/Config/size_config.dart';
import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Services/summary_provider.dart';
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
  List<Ticket> lateTickets = [];
  int noLateTickets = 0;
  int noUrgentTickets = 0;
  int noScheduledTickets = 0;
  double cashReceiptToday = 0;
  double creditReceiptToday = 0;

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
    DateTime lateToday = DateTime.now().subtract(const Duration(days: 4));
    String todayDate = DateTime.now().toString().split(' ')[0];
    DateTime today = DateTime.parse(todayDate);
    print(lateToday.toString());
    noLateTickets = allTickets
        .where((element) => element.dateTime!.isBefore(lateToday))
        .toList()
        .length;

    noScheduledTickets = allTickets
        .where(
          (element) => element.status == STA_QUEUE,
        )
        .toList()
        .length;

    noUrgentTickets = allTickets
        .where(
          (element) => element.isUrgent!,
        )
        .toList()
        .length;

    allCloseTickets.forEach((element) {
      DateTime closeDate = DateTime.parse(element.closeDate!.split(' ')[0]);
      print(closeDate);
      if (closeDate == today) {
        if (element.isCah!) {
          cashReceiptToday += element.totalAmount!;
        }
      }
    });
    // await Provider.of<TicketProvider>(context, listen: false)
    //     .fetchTickets(DB_OPEN_TICKETS);
    // allOpenTickets =
    //     Provider.of<TicketProvider>(context, listen: false).tickets;
    // await Provider.of<TicketProvider>(context, listen: false)
    //     .fetchTickets(DB_DELIVERY_TICKETS);
    // allDeliveryTickets =
    //     Provider.of<TicketProvider>(context, listen: false).tickets;
    // await Provider.of<TicketProvider>(context, listen: false)
    //     .fetchTickets(DB_PICKUP_TICKETS);
    // allPickupTickets =
    //     Provider.of<TicketProvider>(context, listen: false).tickets;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoCard(
                      label: 'Late Tickets',
                      amount: noLateTickets.toString(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InfoCard(
                      label: 'Scheduled Tickets',
                      amount: noScheduledTickets.toString(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoCard(
                      label: 'Urgent Tickets',
                      amount: noUrgentTickets.toString(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InfoCard(
                      label: 'Cash Today',
                      amount: cashReceiptToday.toStringAsFixed(1) + ' SAR',
                    ),
                  ],
                ),
              ]),
            ),
    );
  }
}
