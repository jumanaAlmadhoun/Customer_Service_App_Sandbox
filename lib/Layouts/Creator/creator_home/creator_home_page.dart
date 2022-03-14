import 'dart:convert';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Services/customer_provider.dart';
import 'package:customer_service_app/Services/machines_provider.dart';
import 'package:customer_service_app/Services/summary_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import 'creator_web_home_page.dart';
import 'mobile_create_home_page.dart';

class CreatorHomePage extends StatefulWidget {
  const CreatorHomePage({Key? key}) : super(key: key);

  @override
  _CreatorHomePageState createState() => _CreatorHomePageState();
}

List cities = [];

class _CreatorHomePageState extends State<CreatorHomePage> with RouteAware {
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('Repo/cities.json');
    cities = await json.decode(response) as List<dynamic>;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() async {
    super.didPush();
    readJson();
    Provider.of<MachinesProvider>(context, listen: false).fetchMachines();
    Provider.of<CustomerProvider>(context, listen: false).fetchCustomers();
    Provider.of<SummaryProvider>(context).fetchSummary();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    readJson();
    Provider.of<MachinesProvider>(context, listen: false).fetchMachines();
    Provider.of<CustomerProvider>(context, listen: false).fetchCustomers();
    Provider.of<SummaryProvider>(context).fetchSummary();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < mobileWidth) {
        return MobileCreateHomePage();
      } else {
        return WebCreateHomePage(
          constraints: constraints.maxWidth,
        );
      }
    });
  }
}
