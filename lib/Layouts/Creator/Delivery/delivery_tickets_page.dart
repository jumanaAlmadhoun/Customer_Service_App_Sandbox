import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:flutter/material.dart';

class DeliveryTicketsPage extends StatefulWidget {
  const DeliveryTicketsPage({Key? key}) : super(key: key);

  @override
  _DeliveryTicketsPageState createState() => _DeliveryTicketsPageState();
}

class _DeliveryTicketsPageState extends State<DeliveryTicketsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranselted(context, TIC_DELIVERY)!),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, creatorDeliveryTypeSelection);
              },
              icon: const Icon(Icons.add))
        ],
      ),
    );
  }
}
