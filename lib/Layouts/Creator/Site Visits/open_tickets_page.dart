// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_print

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
import 'package:responsive_framework/responsive_framework.dart';
import '../../../Widgets/Creator/gridviewbuilder_creator.dart';
import '../../../Widgets/logout_widget.dart';
import '../../../Widgets/navigation_bar_item.dart';
import '../../../Widgets/web_layout.dart';

class OpenTickets extends StatefulWidget {
  const OpenTickets({Key? key}) : super(key: key);

  @override
  _OpenTicketsState createState() => _OpenTicketsState();
}

class _OpenTicketsState extends State<OpenTickets> with RouteAware {
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
        .fetchTickets(DB_OPEN_TICKETS)
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
      appBar: AppBar(
        title: _search
            ? TextFormField(
                decoration: InputDecoration(
                    hintText: getTranselted(context, LBL_SEARCH)!,
                    hintStyle: const TextStyle(color: Colors.black)),
                style: const TextStyle(color: Colors.black),
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
              )
            : Text(getTranselted(context, STA_OPEN)!),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _search = !_search;
                if (!_search) {
                  _showedTickets = _tickets;
                }
                print(_search);
              });
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _showedTickets.length,
        itemBuilder: (context, i) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              print('Shady');
              if (dialog != null) {
                setState(() {
                  _isLoading = true;
                });
                Provider.of<TicketProvider>(context, listen: false)
                    .archiveTicket(_showedTickets[i], dialog!.value)
                    .then((value) {
                  if (value == SC_SUCCESS_RESPONSE) {
                    setState(() {
                      _isLoading = false;
                      _showedTickets.remove(_showedTickets[i]);
                    });
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
              customerMobile: _showedTickets[i].customerMobile,
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
        },
      ),
    );
  }
}
