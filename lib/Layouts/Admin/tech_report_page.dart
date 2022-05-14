// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:customer_service_app/Config/size_config.dart';
import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/tech.dart';
import 'package:customer_service_app/Services/tech_provider.dart';
import 'package:customer_service_app/Widgets/Admin/info_card.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../Routes/route_names.dart';
import '../../Widgets/appBar.dart';
import '../../Widgets/logout_widget.dart';
import '../../Widgets/web_layout.dart';

class TechReportPage extends StatefulWidget {
  const TechReportPage({Key? key}) : super(key: key);

  @override
  _TechReportPageState createState() => _TechReportPageState();
}

class _TechReportPageState extends State<TechReportPage> with RouteAware {
  String currDate = DateTime.now().toString().split(' ')[0];
  List<Tech> techsTickets = [];
  bool _isLoading = false;
  int? sortColumnIndex;
  bool isAscending = false;
  int? totalMonthClosed;
  int? totalDayClosed;

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
    Provider.of<TechProvider>(context, listen: false).fetchAll().then((value) {
      techsTickets =
          Provider.of<TechProvider>(context, listen: false).techsReport;
      totalDayClosed =
          Provider.of<TechProvider>(context, listen: false).totalClosedPerDay;
      totalMonthClosed =
          Provider.of<TechProvider>(context, listen: false).totalClosedPerMonth;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Scaffold(
      appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? CustomeAppBar(
              action: const [LogoutWidget()],
              title: Text(
                getTranselted(context, STA_TECHS_REPORT)!,
                style: APPBAR_TEXT_STYLE,
              ),
            )
          : null,
      body: _isLoading
          ? const SpinKitChasingDots(
              color: APP_BAR_COLOR,
            )
          : WebLayout(
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
              widget: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text(
                          currDate,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: BACK_ICON_COLOR),
                        ),
                      ),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 226, 219, 212),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InfoCard(
                        label: 'Total Closed Today',
                        amount: totalDayClosed.toString(),
                      ),
                      InfoCard(
                        label: 'Total Closed This Month',
                        amount: totalMonthClosed.toString(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ScrollableWidget(child: buildDataTable()),
                  )
                ],
              ),
            ),
    );
  }

  Widget buildDataTable() {
    final columns = ['Tech Name', 'Today\'s Tickets', 'Month Tickets'];
    double space = MediaQuery.of(context).size.width * 0.07;

    return Container(
      color: const Color.fromARGB(255, 226, 219, 212),
      width: MediaQuery.of(context).size.width,
      child: DataTable(
        columnSpacing: space,
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(columns),
        rows: getRows(techsTickets),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(
              column,
              style: TextStyle(
                  fontSize: 9), // TODO: implement responsive font size
            ),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<Tech> users) => users.map((Tech user) {
        final cells = [user.name, user.currDayClose, user.currMonthClosed];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      techsTickets.sort(
          (user1, user2) => compareString(ascending, user1.name!, user2.name!));
    } else if (columnIndex == 1) {
      techsTickets.sort((user1, user2) => compareString(
          ascending, '${user1.currDayClose}', '${user2.currDayClose}'));
    } else if (columnIndex == 2) {
      techsTickets.sort((user1, user2) => compareString(
          ascending, '${user1.currMonthClosed}', '${user2.currMonthClosed}'));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}

class ScrollableWidget extends StatelessWidget {
  final Widget child;

  const ScrollableWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: child,
        ),
      );
}
