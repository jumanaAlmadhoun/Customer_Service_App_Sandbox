import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:flutter/material.dart';

import '../../../Helpers/layout_constants.dart';
import '../../../Widgets/category_item.dart';
import '../../../Widgets/gridview_count_widget.dart';

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
        body: GridViewCountWidget(
          widgets: [
            CategoryItem(
              image: IMG_RENT_MACHINE,
              title: getTranselted(context, LBL_MACHINES)!,
              onTap: () {
                Navigator.pushNamed(context, creatorNewMachineDeliveryRoute);
              },
            ),
            CategoryItem(
              image: IMG_BEANS,
              title: getTranselted(context, LBL_BEANS)!,
              onTap: () {
                Navigator.pushNamed(context, creatorPartsDeliveryRoute);
              },
            )
          ],
        ) /* GridView.count(
            crossAxisCount: constraints.maxWidth < ipadWidth ? 2 : 4,
            childAspectRatio: 1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            children: [
            
            ],
          );*/

        );
  }
}
