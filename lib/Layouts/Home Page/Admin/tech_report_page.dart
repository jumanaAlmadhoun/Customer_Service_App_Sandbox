import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/tech.dart';
import 'package:customer_service_app/Services/tech_provider.dart';
import 'package:customer_service_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class TechReportPage extends StatefulWidget {
  const TechReportPage({Key? key}) : super(key: key);

  @override
  _TechReportPageState createState() => _TechReportPageState();
}

class _TechReportPageState extends State<TechReportPage> with RouteAware {
  String currDate = DateTime.now().toString().split(' ')[0];
  List<Tech> techsTickets = [];
  bool _isLoading = false;

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
    setState(() {
      _isLoading = true;
    });
    Provider.of<TechProvider>(context, listen: false).fetchAll().then((value) {
      techsTickets =
          Provider.of<TechProvider>(context, listen: false).techsReport;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranselted(context, STA_TECHS_REPORT)!),
      ),
      body: _isLoading
          ? const SpinKitChasingDots(
              color: APP_BAR_COLOR,
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      currDate,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                Container(
                  height: 50,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Tech Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Today\'s Tickets',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Month Tickets',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                  ),
                ),
                ListView.builder(
                  itemCount: techsTickets.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, i) {
                    return Container(
                      height: 50,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              techsTickets[i].name!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              techsTickets[i].currDayClose.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              techsTickets[i].currMonthClosed.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                      decoration: BoxDecoration(
                        color: i % 2 == 0
                            ? Colors.grey.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.3),
                      ),
                    );
                  },
                )
              ],
            ),
    );
  }
}
