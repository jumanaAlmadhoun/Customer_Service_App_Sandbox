import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/summary_provider.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../Helpers/layout_constants.dart';
import '../../../Widgets/appBar.dart';
import '../../../Widgets/Admin/gridview_builder_widget.dart';
import '../../../Widgets/logout_widget.dart';
import '../../../Widgets/navigation_bar_item.dart';
import '../../../Widgets/web_layout.dart';

class QueueTikcketsPage extends StatefulWidget {
  const QueueTikcketsPage({Key? key}) : super(key: key);

  @override
  _QueueTikcketsPageState createState() => _QueueTikcketsPageState();
}

class _QueueTikcketsPageState extends State<QueueTikcketsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? CustomeAppBar(
              action: const [LogoutWidget()],
              title: Text(
                getTranselted(context, STA_QUEUE)!,
                style: APPBAR_TEXT_STYLE,
              ),
            )
          : null,
      body: WebLayout(
        navItem: [
          NavigationBarItem(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, creatorHomeRoute, (route) {
              ModalRoute.withName(creatorHomeRoute);
              return false;
            }),
            text: getTranselted(context, HOME_PAGE_TITLE)!,
          ),
          NavigationBarItem(
            onTap: () => Navigator.pushNamed(context, creatorDashBoardRoute),
            text: 'Dashboard',
          ),
          NavigationBarItem(
            onTap: () {},
            text: getTranselted(context, TODAY_TICKETS)!,
          ),
          NavigationBarItem(
            onTap: () {},
            text: getTranselted(context, CUSTOMER_MGMT)!,
          ),
          NavigationBarItem(
            onTap: () {},
            text: getTranselted(context, SETTINGS)!,
          ),
          const LogoutWidget(),
        ],
        widget: /* GridViewBuilder(
          list: techs,
        ),*/
            LayoutBuilder(builder: (context, constraints) {
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth < mobileWidth
                      ? 1
                      : constraints.maxWidth < ipadWidth
                          ? 2
                          : 3,
                  childAspectRatio:
                      constraints.maxWidth < mobileWidth ? 6 : 4.5),
              itemCount: techs.length,
              itemBuilder: (context, i) {
                return techs[i].queueTicket != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Text(techs[i].name!),
                              trailing:
                                  Text(techs[i].queueTicket!.length.toString()),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, creatorTechQueueTicketRoute,
                                    arguments: techs[i]);
                              },
                            )),
                      )
                    : Container();
              });
        }),
      ),
    );
  }
}
