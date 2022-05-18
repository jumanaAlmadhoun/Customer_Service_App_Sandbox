// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:customer_service_app/Config/size_config.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/rfa_machines_provider.dart';
import 'package:customer_service_app/Widgets/category_item.dart';
import 'package:customer_service_app/Widgets/logout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../Widgets/appBar.dart';
import '../../Widgets/gridview_count_widget.dart';
import '../../Widgets/navigation_bar_item.dart';
import '../../Widgets/web_layout.dart';
import '../../main.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    super.didPush();
    Provider.of<RfaMachinesProvider>(context).fetchRfaMachines();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? CustomeAppBar(
              action: const [LogoutWidget()],
              title: Text(
                getTranselted(context, HOME_PAGE_TITLE)!,
                style: APPBAR_TEXT_STYLE,
              ),
            )
          : null,
      body: WebLayout(
        navItem: [
          NavigationBarItem(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, adminHomeRoute, (route) {
              ModalRoute.withName(adminHomeRoute);
              return false;
            }),
            text: getTranselted(context, HOME_PAGE_TITLE)!,
          ),
          const SizedBox(
            width: 50,
          ),
          const LogoutWidget(),
        ],
        widget: GridViewCountWidget(
          widgets: [
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
        ),
      ),
    );
  }
}
