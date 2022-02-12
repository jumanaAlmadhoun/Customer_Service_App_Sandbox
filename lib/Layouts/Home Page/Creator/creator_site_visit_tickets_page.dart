import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Widgets/category_item.dart';
import 'package:flutter/material.dart';

class CreatorSiteVisitPage extends StatefulWidget {
  const CreatorSiteVisitPage({Key? key}) : super(key: key);

  @override
  _CreatorSiteVisitPageState createState() => _CreatorSiteVisitPageState();
}

class _CreatorSiteVisitPageState extends State<CreatorSiteVisitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranselted(context, TIC_SITE_VISIT)!),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, brandSelectionRoute);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: .70,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          children: [
            CategoryItem(
              image: IMG_OPEN_TICKETS,
              title: getTranselted(context, STA_OPEN)!,
            ),
            CategoryItem(
              image: IMG_WAITING_TICKETS,
              title: getTranselted(context, STA_WAITING)!,
            ),
            CategoryItem(
              image: IMG_QUEUE_TICKETS,
              title: getTranselted(context, STA_QUEUE)!,
            ),
            CategoryItem(
              image: IMG_ASSIGNED_TICKETS,
              title: getTranselted(context, STA_ASSIGNED)!,
            ),
            CategoryItem(
              image: IMG_PENDING_TICKETS,
              title: getTranselted(context, STA_PENDING)!,
            ),
          ],
        ));
  }
}
