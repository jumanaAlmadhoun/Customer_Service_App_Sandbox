import 'dart:convert';

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/summary_provider.dart';
import 'package:customer_service_app/Widgets/category_item.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class CreatorSiteVisitPage extends StatefulWidget {
  const CreatorSiteVisitPage({Key? key}) : super(key: key);

  @override
  _CreatorSiteVisitPageState createState() => _CreatorSiteVisitPageState();
}

class _CreatorSiteVisitPageState extends State<CreatorSiteVisitPage>
    with RouteAware {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    super.didPush();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranselted(context, TIC_SITE_VISIT)!),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, brandSelectionRoute);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: .70,
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
              Navigator.pushNamed(context, creatorReadyToAssignTicketsRoute);
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
      ),
    );
  }
}
