import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/rfa_machine.dart';
import 'package:customer_service_app/Services/rfa_machines_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../Routes/route_names.dart';
import '../../Widgets/appBar.dart';
import '../../Widgets/gridview_builder_widget.dart';
import '../../Widgets/logout_widget.dart';
import '../../Widgets/web_layout.dart';

class RentMachineDashboard extends StatefulWidget {
  const RentMachineDashboard({Key? key}) : super(key: key);

  @override
  _RentMachineDashboardState createState() => _RentMachineDashboardState();
}

class _RentMachineDashboardState extends State<RentMachineDashboard> {
  @override
  Widget build(BuildContext context) {
    List<RfaMachine> machines =
        Provider.of<RfaMachinesProvider>(context, listen: false).machines;
    machines.sort((a, b) => b.status!.compareTo(a.status!));
    return Scaffold(
      appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? CustomeAppBar(
              action: const [LogoutWidget()],
              title: Text(
                getTranselted(context, STA_RENT_MACHINES)!,
                style: APPBAR_TEXT_STYLE,
              ),
            )
          : null,
      body: WebLayout(
          navItem: [
            InkWell(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, adminHomeRoute, (route) {
                ModalRoute.withName(adminHomeRoute);
                return false;
              }),
              child: Text(
                getTranselted(context, HOME_PAGE_TITLE)!,
                style: APPBAR_TEXT_STYLE,
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            const LogoutWidget(),
          ],
          widget: GridViewBuilder(
            list: machines,
          )),
    );
  }
}
