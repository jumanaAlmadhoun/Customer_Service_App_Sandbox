import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/summary_provider.dart';
import 'package:flutter/material.dart';

import '../../../Helpers/layout_constants.dart';

class QueueTikcketsPage extends StatefulWidget {
  const QueueTikcketsPage({Key? key}) : super(key: key);

  @override
  _QueueTikcketsPageState createState() => _QueueTikcketsPageState();
}

class _QueueTikcketsPageState extends State<QueueTikcketsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranselted(context, STA_QUEUE)!),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth < mobileWidth
                    ? 1
                    : constraints.maxWidth > ipadWidth
                        ? 3
                        : 2,
                childAspectRatio: constraints.maxWidth < mobileWidth
                    ? 2.5
                    : constraints.maxWidth < ipadWidth
                        ? 1.3
                        : 1.2),
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
    );
  }
}
