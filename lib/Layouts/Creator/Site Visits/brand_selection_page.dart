import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Layouts/Creator/Site%20Visits/sanremo_new_ticket_page.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Widgets/category_item.dart';
import 'package:flutter/material.dart';

class BrandSelectionPage extends StatelessWidget {
  const BrandSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranselted(context, BRAND_SELECTION)!),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => GridView.count(
            crossAxisCount: constraints.maxWidth < mobileWidth
                ? 2
                : constraints.maxWidth > ipadWidth
                    ? 4
                    : 3,
            childAspectRatio: constraints.maxWidth < mobileWidth ? 0.99 : 1.1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            children: [
              CategoryItem(
                image: ESPRESSO_MACHINES,
                title: 'Espresso Machines',
                onTap: () {
                  Navigator.pushNamed(context, sanremoNewTicketRoute,
                      arguments: 'Espresso Machines');
                },
              ),
              CategoryItem(
                image: Coffee_grinders,
                title: 'Coffee Grinders',
                onTap: () {
                  Navigator.pushNamed(context, sanremoNewTicketRoute,
                      arguments: 'Coffee Grinders');
                },
              ),
              CategoryItem(
                image: BatchBrewer,
                title: 'Batch Brewer',
                onTap: () {
                  Navigator.pushNamed(context, sanremoNewTicketRoute,
                      arguments: 'Batch Brewer');
                },
              ),
              CategoryItem(
                image: Perfect_Moose,
                title: 'Perfect Moose',
                onTap: () {
                  Navigator.pushNamed(context, sanremoNewTicketRoute,
                      arguments: 'Perfect Moose');
                },
              ),
              CategoryItem(
                image: TAMPERS,
                title: 'Tampers',
                onTap: () {},
              ),
            ],
          ),
        ));
  }
}
