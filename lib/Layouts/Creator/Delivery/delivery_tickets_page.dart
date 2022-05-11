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
                onChanged: (value) {
                  setState(() {
                    try {
                      _showedTickets = _tickets
                          .where((element) =>
                              element.searchText!.contains(value.toUpperCase()))
                          .toList();
                    } catch (ex) {
                      print(ex);
                    }
                  });
                },
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
          : ListView.builder(
              itemCount: _showedTickets.length,
              itemBuilder: (context, i) {
                return DeliveryTicketWidget(
                  cafeName: _showedTickets[i].cafeName,
                  city: _showedTickets[i].city,
                  customerMobile: _showedTickets[i].extraContactNumber,
                  customerName: _showedTickets[i].customerName,
                  date: _showedTickets[i].creationDate,
                  didContact: _showedTickets[i].didContact,
                  techName: _showedTickets[i].techName,
                  type: _showedTickets[i].subCategory,
                  deliveryType: _showedTickets[i].status,
                  onTap: () {
                    if (_showedTickets[i].subCategory ==
                        Ticket.PARTS_DELIVERY) {
                      Navigator.pushNamed(
                          context, creatorEditPartsDeliveryRoute,
                          arguments: _showedTickets[i]);
                    } else {
                      Navigator.pushNamed(
                          context, creatorEditNewMachineDeliveryRoute,
                          arguments: _showedTickets[i]);
                    }
                  },
                );
              },
            ),
    );
  }
}
