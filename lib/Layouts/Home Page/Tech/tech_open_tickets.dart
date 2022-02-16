import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/tech_ticket_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class TechOpenTicketPage extends StatefulWidget {
  const TechOpenTicketPage({Key? key}) : super(key: key);

  @override
  _TechOpenTicketPageState createState() => _TechOpenTicketPageState();
}

class _TechOpenTicketPageState extends State<TechOpenTicketPage>
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
        .fetchTickets('$DB_ASSIGNED_TICKETS/$userName')
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
        title: const Text('التذاكر المسندة'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _search = !_search;
              });
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: _isLoading
          ? const SpinKitRipple(
              color: APP_BAR_COLOR,
            )
          : ListView.builder(
              itemCount: _tickets.length,
              itemBuilder: (context, i) {
                return TechTicketWidget(
                  cafeName: _tickets[i].cafeName,
                  city: _tickets[i].city,
                  customerMobile: _tickets[i].extraContactNumber,
                  customerName: _tickets[i].customerName,
                  date: _tickets[i].creationDate,
                  didContact: _tickets[i].didContact,
                  onTap: () {},
                );
              },
            ),
    );
  }
}
