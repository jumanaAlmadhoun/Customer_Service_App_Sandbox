import 'package:customer_service_app/Config/size_config.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/rfa_machines_provider.dart';
import 'package:customer_service_app/Widgets/category_item.dart';
import 'package:customer_service_app/Widgets/logout_widget.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> with RouteAware {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    // TODO: implement didPush
    super.didPush();
    Provider.of<RfaMachinesProvider>(context).fetchRfaMachines();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranselted(context, HOME_PAGE_TITLE)!),
        actions: const [LogoutWidget()],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.count(
            crossAxisCount: constraints.maxWidth < mobileWidth
                ? 2
                : constraints.maxWidth < mobileWidth
                    ? 2
                    : constraints.maxWidth > ipadWidth
                        ? 4
                        : 3,
            childAspectRatio: constraints.maxWidth < mobileWidth ? 0.70 : 0.9,
            children: [
              totalRfaMachines == -1
                  ? const SpinKitDancingSquare(
                      color: APP_BAR_COLOR,
                    )
                  : CategoryItem(
                      title: getTranselted(context, STA_RENT_MACHINES)!,
                      image: IMG_RENT_MACHINE,
                      number: totalRfaMachines,
                      onTap: () {
                        Navigator.pushNamed(context, adminRentMachineRoute);
                      },
                    ),
              totalRfaMachines == -1
                  ? const SpinKitDancingSquare(
                      color: APP_BAR_COLOR,
                    )
                  : CategoryItem(
                      title: getTranselted(context, STA_TECHS_REPORT)!,
                      image: IMG_TECH_REPORT,
                      onTap: () {
                        Navigator.pushNamed(context, adminTechReportRoute);
                      },
                    ),
              totalRfaMachines == -1
                  ? const SpinKitDancingSquare(
                      color: APP_BAR_COLOR,
                    )
                  : CategoryItem(
                      title: getTranselted(context, STA_TECHS_REPORT)!,
                      image: IMG_WORKSHO_REPORT,
                      onTap: () {
                        Navigator.pushNamed(context, adminTechReportRoute);
                      },
                    ),
            ],
          );
        },
      ),
    );
  }
}
