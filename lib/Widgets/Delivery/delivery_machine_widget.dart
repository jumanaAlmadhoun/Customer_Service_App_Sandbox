import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/machine.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:customer_service_app/Util/formatters.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class DeliveryMachineWidget extends StatefulWidget {
  DeliveryMachineWidget({this.allModels, this.machines});
  TextEditingController machineModel = TextEditingController();
  TextEditingController machineNumber = TextEditingController();
  TextEditingController qty = TextEditingController();
  List<String>? allModels;
  List<Machine>? machines;

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
                suggestions: widget.allModels!
                    .map((e) => SearchFieldListItem(e.toString()))
                    .toList(),
              ),
            ),
            widget.allModels == null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      inputFormatters: [UpperCaseFormatter()],
                      controller: widget.machineNumber,
                      decoration: InputDecoration(
                          label: Text(
                              getTranselted(context, LBL_MACHINE_NUMBER)!)),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchField(
                      searchInputDecoration: InputDecoration(
                        label:
                            Text(getTranselted(context, LBL_MACHINE_NUMBER)!),
                      ),
                      controller: widget.machineNumber,
                      onTap: (searchElement) {
                        setState(() {
                          widget.machineNumber.text = searchElement.searchKey;
                          widget.machineModel.text = widget.machines!
                              .firstWhere((element) =>
                                  element.machineNumber!.toUpperCase() ==
                                  searchElement.searchKey.toUpperCase())
                              .machineModel
                              .toString();
                        });
                      },
                      suggestions: widget.machines!
                          .map((e) =>
                              SearchFieldListItem(e.machineNumber.toString()))
                          .toList(),
                    ),
                  ),
            widget.allModels == null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: widget.qty,
                      decoration: InputDecoration(
                          label: Text(getTranselted(context, LBL_QTY)!)),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
