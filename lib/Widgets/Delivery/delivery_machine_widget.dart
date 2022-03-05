import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:customer_service_app/Util/formatters.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class DeliveryMachineWidget extends StatefulWidget {
  DeliveryMachineWidget({this.allModels});
  TextEditingController machineModel = TextEditingController();
  TextEditingController machineNumber = TextEditingController();
  TextEditingController qty = TextEditingController();
  List<String>? allModels;

  @override
  _DeliveryMachineWidgetState createState() => _DeliveryMachineWidgetState();
}

class _DeliveryMachineWidgetState extends State<DeliveryMachineWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: APP_BAR_COLOR),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchField(
                maxSuggestionsInViewPort: 5,
                searchInputDecoration: InputDecoration(
                  label: Text(getTranselted(context, LBL_MACHINE_MODEL)!),
                ),
                controller: widget.machineModel,
                suggestions: widget.allModels!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                inputFormatters: [UpperCaseFormatter()],
                controller: widget.machineNumber,
                decoration: InputDecoration(
                    label: Text(getTranselted(context, LBL_MACHINE_NUMBER)!)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: widget.qty,
                decoration: InputDecoration(
                    label: Text(getTranselted(context, LBL_QTY)!)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
