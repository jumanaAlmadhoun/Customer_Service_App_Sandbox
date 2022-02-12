import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Widgets/category_item.dart';
import 'package:customer_service_app/Widgets/creator_nav_bar.dart';
import 'package:flutter/material.dart';

class CreatorHomePage extends StatefulWidget {
  const CreatorHomePage({Key? key}) : super(key: key);

  @override
  _CreatorHomePageState createState() => _CreatorHomePageState();
}

class _CreatorHomePageState extends State<CreatorHomePage> {
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

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(getTranselted(context, HOME_PAGE_TITLE)!),
      centerTitle: true,
    );
  }
}
