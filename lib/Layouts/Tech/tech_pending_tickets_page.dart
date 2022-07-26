// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:customer_service_app/Helpers/database_constants.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Models/ticket.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:customer_service_app/Services/ticket_provider.dart';
import 'package:customer_service_app/Widgets/Admin/primary_text.dart';
import 'package:customer_service_app/Widgets/Tech/tech_ticket_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../main.dart';
import '../../Localization/localization_constants.dart';
import '../../Widgets/logout_widget.dart';
import '../../Widgets/web_layout.dart';

class TechPendingTicketsPage extends StatefulWidget {
  const TechPendingTicketsPage({Key? key}) : super(key: key);

  @override
  _TechPendingTicketsPageState createState() => _TechPendingTicketsPageState();
}

class _TechPendingTicketsPageState extends State<TechPendingTicketsPage>
    with RouteAware {
  List<Ticket> _tickets = [];
  bool _isLoading = false;
  bool _search = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    super.didPush();
    setState(() {
      _isLoading = true;
    });
    Provider.of<TicketProvider>(context, listen: false)
        .fetchPendingTickets('$DB_WAITING_CONFIRMATION/$userName')
        .then((value) {
      setState(() {
        _isLoading = false;
        _tickets = Provider.of<TicketProvider>(context, listen: false).tickets;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? AppBar(
              title: const Text('تذاكر بانتظار الاعتماد'),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _search = !_search;
                    });
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            )
          : null,
      body: WebLayout(
        navItem: [
          InkWell(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, techHomeRoute, (route) {
              ModalRoute.withName(techHomeRoute);
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
        widget: _isLoading
            ? const SpinKitRipple(
                color: APP_BAR_COLOR,
              )
            : _tickets.isNotEmpty
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ResponsiveWrapper.of(context)
                                .isSmallerThan(TABLET)
                            ? 1
                            : (ResponsiveWrapper.of(context)
                                        .isLargerThan(MOBILE) &&
                                    ResponsiveWrapper.of(context)
                                        .isSmallerThan(DESKTOP))
                                ? 3
                                : 4,
                        childAspectRatio:
                            ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                                ? 2
                                : (ResponsiveWrapper.of(context)
                                            .isLargerThan(MOBILE) &&
                                        ResponsiveWrapper.of(context)
                                            .isSmallerThan(DESKTOP))
                                    ? 1.2
                                    : 1.2),
                    itemCount: _tickets.length,
                    itemBuilder: (context, i) {
                      return TechTicketWidget(
                        cafeName: _tickets[i].cafeName,
                        city: _tickets[i].city,
                        customerMobile: _tickets[i].extraContactNumber,
                        customerName: _tickets[i].customerName,
                        date: _tickets[i].creationDate,
                        didContact: _tickets[i].didContact,
                        onTap: () {
                          Navigator.pushNamed(
                              context, techEditRejectedTicketRoute,
                              arguments: _tickets[i]);
                        },
                      );
                    },
                  )
                : Center(child: PrimaryText(text: 'لا توجد تذاكر')),
      ),
    );
  }
}
