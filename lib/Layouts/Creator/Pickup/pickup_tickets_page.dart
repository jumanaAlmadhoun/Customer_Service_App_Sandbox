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
                Navigator.pushNamed(context, creatorNewPickupTicketRoute);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: _isLoading
          ? const SpinKitRipple(
              color: APP_BAR_COLOR,
            )
          : ListView.builder(
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
                    Navigator.pushNamed(context, creatorEditPickupTicketRoute,
                        arguments: _tickets[i]);
                  },
                );
              },
            ),
    );
  }
}
