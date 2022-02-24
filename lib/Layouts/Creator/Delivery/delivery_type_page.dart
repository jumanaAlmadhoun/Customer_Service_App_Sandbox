import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:flutter/material.dart';

import '../../../Helpers/layout_constants.dart';
import '../../../Widgets/category_item.dart';

class DeliveryTypePage extends StatefulWidget {
  const DeliveryTypePage({Key? key}) : super(key: key);

  @override
  _DeliveryTypePageState createState() => _DeliveryTypePageState();
}

class _DeliveryTypePageState extends State<DeliveryTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranselted(context, LBL_DELIVERY_TYPE)!),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: .70,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          children: [
            CategoryItem(
              image: IMG_RENT_MACHINE,
              title: getTranselted(context, LBL_MACHINES)!,
              onTap: () {
                // Navigator.pushNamed(context, creatorOpenTicketsRoute);
              },
            ),
            CategoryItem(
              image: IMG_BEANS,
              title: getTranselted(context, LBL_BEANS)!,
              onTap: () {
                // Navigator.pushNamed(context, creatorReadyToAssignTicketsRoute);
              },
            )
          ],
        ));
  }
}
