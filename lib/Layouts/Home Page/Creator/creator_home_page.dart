import 'dart:convert';

import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/customer_provider.dart';
import 'package:customer_service_app/Services/machines_provider.dart';
import 'package:customer_service_app/Widgets/category_item.dart';
import 'package:customer_service_app/Widgets/creator_nav_bar.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
    // TODO: implement didPush
    super.didPush();
    readJson();
    Provider.of<MachinesProvider>(context, listen: false).fetchMachines();
    Provider.of<CustomerProvider>(context, listen: false).fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranselted(context, HOME_PAGE_TITLE)!),
      ),
      drawer: const CreatorDrawerWidget(),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: .70,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        children: [
          CategoryItem(
            title: getTranselted(context, TIC_SITE_VISIT)!,
            image: IMG_SITE_VISIT,
            onTap: () {
              Navigator.pushNamed(context, creatorSiteVisitRoute);
            },
          ),
          CategoryItem(
            title: getTranselted(context, TIC_DELIVERY)!,
            image: IMG_DELIVERY,
          ),
          CategoryItem(
            title: getTranselted(context, TIC_EXCHANGE)!,
            image: IMG_EXCHANGE,
          ),
          CategoryItem(
            title: getTranselted(context, TIC_PICK_UP)!,
            image: IMG_PICKUP,
          ),
          CategoryItem(
            title: getTranselted(context, TIC_ACCOUNTING)!,
            image: IMG_ACCOUNTING,
          ),
        ],
      ),
    );
  }
}
