import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../Helpers/layout_constants.dart';
import '../../../../Localization/localization_constants.dart';
import '../../../../Routes/route_names.dart';
import '../../../../Services/summary_provider.dart';
import '../../../../Widgets/category_item.dart';
import '../../../../Widgets/creator_nav_bar.dart';
import '../../../../Widgets/logout_widget.dart';

class MobileCreateHomePage extends StatelessWidget {
  const MobileCreateHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranselted(context, HOME_PAGE_TITLE)!),
        actions: const [LogoutWidget()],
      ),
      drawer: const CreatorDrawerWidget(),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: .70,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        children: [
          siteVisitTickets == -1
              ? const SpinKitDancingSquare(
                  color: APP_BAR_COLOR,
                )
              : CategoryItem(
                  title: getTranselted(context, TIC_SITE_VISIT)!,
                  image: IMG_SITE_VISIT,
                  number: siteVisitTickets,
                  onTap: () {
                    Navigator.pushNamed(context, creatorSiteVisitRoute);
                  },
                ),
          deliveryTickets == -1
              ? const SpinKitDancingSquare(
                  color: APP_BAR_COLOR,
                )
              : CategoryItem(
                  title: getTranselted(context, TIC_DELIVERY)!,
                  image: IMG_DELIVERY,
                  number: deliveryTickets,
                  onTap: () {
                    Navigator.pushNamed(context, creatorDeliveryTicketsRoute);
                  },
                ),
          exchangeTickets == -1
              ? const SpinKitDancingSquare(
                  color: APP_BAR_COLOR,
                )
              : CategoryItem(
                  title: getTranselted(context, TIC_EXCHANGE)!,
                  image: IMG_EXCHANGE,
                  number: exchangeTickets,
                ),
          pickupTickets == -1
              ? const SpinKitDancingSquare(
                  color: APP_BAR_COLOR,
                )
              : CategoryItem(
                  title: getTranselted(context, TIC_PICK_UP)!,
                  image: IMG_PICKUP,
                  number: pickupTickets,
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
