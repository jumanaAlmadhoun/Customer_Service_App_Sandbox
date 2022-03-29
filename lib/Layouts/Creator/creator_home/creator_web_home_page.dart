import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../Helpers/layout_constants.dart';
import '../../../../Localization/localization_constants.dart';
import '../../../../Routes/route_names.dart';
import '../../../../Services/summary_provider.dart';
import '../../../../Widgets/category_item.dart';
import '../../../../Widgets/logout_widget.dart';
import '../../../../Widgets/navigation_bar_item.dart';

class WebCreateHomePage extends StatelessWidget {
  double? constraints;
  WebCreateHomePage({required this.constraints, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> navigationItems = [
      Padding(
        padding: const EdgeInsets.all(6.0),
        child: Image.asset(IMG_LOGO),
      ),
      NavigationBarItem(
        text: getTranselted(context, HOME_PAGE_TITLE)!,
      ),
      NavigationBarItem(
        text: getTranselted(context, TODAY_TICKETS)!,
      ),
      NavigationBarItem(
        text: getTranselted(context, CUSTOMER_MGMT)!,
      ),
      NavigationBarItem(
        text: getTranselted(context, SETTINGS)!,
      ),
      const LogoutWidget(),
    ];
    return Scaffold(
        body: Column(
      children: [
        Container(
          color: Color.fromARGB(255, 245, 232, 161),
          height: 90.0,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: navigationItems),
        ),
        Expanded(
          child: GridView.count(
            padding: EdgeInsets.all(15.0),
            crossAxisCount: constraints! < ipadWidth ? 3 : 4,
            childAspectRatio: 0.9,
            crossAxisSpacing: 19,
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
                        Navigator.pushNamed(
                            context, creatorDeliveryTicketsRoute);
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
                      onTap: () {
                        Navigator.pushNamed(context, creatorPickupTicketsRoute);
                      },
                    ),
              CategoryItem(
                title: getTranselted(context, TIC_ACCOUNTING)!,
                image: IMG_ACCOUNTING,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
