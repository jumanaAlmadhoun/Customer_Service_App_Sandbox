import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
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
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: .70,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        children: [
          CategoryItem(
            image: IMG_LOGO_SANREMO,
            title: 'Sanremo',
            onTap: () {
              Navigator.pushNamed(context, sanremoNewTicketRoute,
                  arguments: TEMP_SANREMO);
            },
          ),
          CategoryItem(
            image: IMG_LOGO_PM,
            title: 'Perfect Moose',
            onTap: () {},
          ),
          CategoryItem(
            image: IMG_LOGO_CEADO,
            title: 'Ceado',
            onTap: () {},
          ),
          CategoryItem(
            image: IMG_LOGO_SIPRESSO,
            title: 'Sipresso',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
