import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/rfa_machine.dart';
import 'package:customer_service_app/Services/rfa_machines_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        appBar: AppBar(
          title: Text(getTranselted(context, STA_RENT_MACHINES)!),
        ),
        body: ListView.builder(
          itemCount: machines.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: APP_BAR_COLOR, width: 1),
                    borderRadius: BorderRadius.circular(15),
                    color: machines[i].status == 'With Customer'
                        ? NOT_CONTACTED_COLOR
                        : CONTACTED_COLOR),
                child: ListTile(
                  title: Text(
                    machines[i].machineModel!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(machines[i].serialNumber!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text(machines[i].location!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  leading: Text(machines[i].status!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            );
          },
        ));
  }
}
