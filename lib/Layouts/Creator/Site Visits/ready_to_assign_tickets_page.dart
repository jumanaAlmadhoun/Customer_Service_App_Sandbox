import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/global_vars.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Helpers/scripts_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/Creator/custom_list_dialgo.dart';
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
  CustomListDialog? dialog;

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
                    hintText: getTranselted(context, LBL_SEARCH)!,
                    hintStyle: const TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _showedTickets = _tickets
                        .where((element) =>
                            element.searchText!.contains(value.toUpperCase()))
                        .toList();
                  });
                },
              )
            : Text(getTranselted(context, STA_WAITING)!),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _search = !_search;
                if (!_search) {
                  _showedTickets = _tickets;
                }
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
                  itemCount: _showedTickets.length,
                  itemBuilder: (context, i) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) async {
                        if (dialog != null) {
                          Provider.of<TicketProvider>(context, listen: false)
                              .archiveTicket(_showedTickets[i], dialog!.value)
                              .then((value) async {
                            if (value == SC_SUCCESS_RESPONSE) {
                              _showedTickets.remove(_showedTickets[i]);
                            } else {}
                          });
                        }
                      },
                      confirmDismiss: (direction) async {
                        dialog = CustomListDialog(
                          msg: 'Archive Ticket',
                          items: archiveReasons,
                        );
                        return await showDialog(
                            context: context, builder: (_) => dialog!);
                      },
                      child: OpenTicketWidget(
                        cafeName: _showedTickets[i].cafeName,
                        city: _showedTickets[i].city,
                        customerMobile: _showedTickets[i].extraContactNumber,
                        customerName: _showedTickets[i].customerName,
                        date: _showedTickets[i].creationDate,
                        didContact: _showedTickets[i].didContact,
                        machineNumber: _showedTickets[i].machineNumber,
                        onTap: () {
                          Navigator.pushNamed(context, sanremoEditTicketRoute,
                              arguments: _showedTickets[i]);
                        },
                      ),
                    );
                  });
            }),
    );
  }
}
