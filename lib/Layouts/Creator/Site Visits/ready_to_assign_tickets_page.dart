import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/open_ticket_widget.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ReadyToAssignTickets extends StatefulWidget {
  const ReadyToAssignTickets({Key? key}) : super(key: key);

  @override
  _ReadyToAssignTicketsState createState() => _ReadyToAssignTicketsState();
}

class _ReadyToAssignTicketsState extends State<ReadyToAssignTickets>
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
        .fetchTickets(DB_READY_TO_ASSIGN_TICKETS)
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
                decoration: InputDecoration(
                    hintText: getTranselted(context, LBL_SEARCH)!),
              )
            : Text(getTranselted(context, STA_OPEN)!),
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
          : LayoutBuilder(builder: (context, constraints) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraints.maxWidth < mobileWidth
                          ? 1
                          : constraints.maxWidth > ipadWidth
                              ? 3
                              : 2,
                      childAspectRatio: constraints.maxWidth < mobileWidth
                          ? 2.5
                          : constraints.maxWidth < ipadWidth
                              ? 1.3
                              : 1.2),
                  itemCount: _tickets.length,
                  itemBuilder: (context, i) {
                    return OpenTicketWidget(
                      cafeName: _tickets[i].cafeName,
                      city: _tickets[i].city,
                      customerMobile: _tickets[i].extraContactNumber,
                      customerName: _tickets[i].customerName,
                      date: _tickets[i].creationDate,
                      didContact: _tickets[i].didContact,
                      machineNumber: _tickets[i].machineNumber,
                      onTap: () {
                        Navigator.pushNamed(context, sanremoEditTicketRoute,
                            arguments: _tickets[i]);
                      },
                    );
                  });
            }),
    );
  }
}
