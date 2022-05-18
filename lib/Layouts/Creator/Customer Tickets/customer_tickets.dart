import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerTicketsPage extends StatefulWidget {
  const CustomerTicketsPage({Key? key}) : super(key: key);

  @override
  State<CustomerTicketsPage> createState() => _CustomerTicketsPageState();
}

class _CustomerTicketsPageState extends State<CustomerTicketsPage>
    with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    super.didPush();
    Provider.of<TicketProvider>(context, listen: false).fetchCustomerTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
