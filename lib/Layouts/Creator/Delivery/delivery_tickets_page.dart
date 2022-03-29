import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/Delivery/delivery_open_ticket_widget.dart';
import 'package:customer_service_app/Widgets/open_ticket_widget.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/creator_nav_bar.dart';

class DeliveryTicketsPage extends StatefulWidget {
  const DeliveryTicketsPage({Key? key}) : super(key: key);

  @override
  _DeliveryTicketsPageState createState() => _DeliveryTicketsPageState();
}

class _DeliveryTicketsPageState extends State<DeliveryTicketsPage>
    with RouteAware {
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
        .fetchTickets(DB_DELIVERY_TICKETS)
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
    return Scaffold(
      appBar: AppBar(
        title: _search
            ? TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: getTranselted(context, LBL_SEARCH)!,
                  hintStyle: const TextStyle(color: Colors.white),
                ),
              )
            : Text(getTranselted(context, TIC_DELIVERY)!),
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
                Navigator.pushNamed(context, creatorDeliveryTypeSelection);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: _isLoading
          ? const SpinKitRipple(
              color: APP_BAR_COLOR,
            )
          : LayoutBuilder(
              builder: (context, constraints) => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth < mobileWidth
                      ? 1
                      : constraints.maxWidth < ipadWidth
                          ? 2
                          : 3,
                  childAspectRatio: constraints.maxWidth < mobileWidth
                      ? 2.3
                      : constraints.maxWidth < ipadWidth
                          ? 1.4
                          : 1.3,
                ),
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
                    deliveryType: _tickets[i].deliveryType,
                    onTap: () {
                      if (_tickets[i].subCategory == Ticket.PARTS_DELIVERY) {
                        Navigator.pushNamed(
                            context, creatorEditPartsDeliveryRoute,
                            arguments: _tickets[i]);
                      } else {
                        Navigator.pushNamed(
                            context, creatorEditNewMachineDeliveryRoute,
                            arguments: _tickets[i]);
                      }
                    },
                  );
                },
              ),
            ),
    );
  }
}
