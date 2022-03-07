import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/summary_provider.dart';
import 'package:flutter/material.dart';

class AssignedTikcketsPage extends StatefulWidget {
  const AssignedTikcketsPage({Key? key}) : super(key: key);

  @override
  _AssignedTikcketsPageState createState() => _AssignedTikcketsPageState();
}

class _AssignedTikcketsPageState extends State<AssignedTikcketsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranselted(context, STA_ASSIGNED)!),
      ),
      body: ListView.builder(
        itemCount: techs.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Text(techs[i].name!),
                trailing: Text(techs[i].assignedTickets!.length.toString()),
                onTap: () {
                  Navigator.pushNamed(context, creatorTechAssignedTicketRoute,
                      arguments: techs[i]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
