import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class DeliveryItemWidget extends StatefulWidget {
  DeliveryItemWidget({this.allParts});
  TextEditingController partNo = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController desc = TextEditingController();
  List<SparePart>? allParts;

  @override
  _DeliveryItemWidgetState createState() => _DeliveryItemWidgetState();
}

class _DeliveryItemWidgetState extends State<DeliveryItemWidget> {
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
                  label: Text(getTranselted(context, LBL_ITEM_NO)!),
                ),
                controller: widget.partNo,
                suggestions:
                    widget.allParts!.map((e) => e.partNo.toString()).toList(),
                onTap: (value) {
                  SparePart part = widget.allParts!.firstWhere((element) =>
                      element.partNo!.toUpperCase() == value!.toUpperCase());
                  if (part != null) {
                    setState(() {
                      widget.desc.text = part.desc!;
                    });
                  } else {
                    setState(() {
                      widget.desc.text = '';
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                enabled: false,
                controller: widget.desc,
                decoration: InputDecoration(
                    label: Text(getTranselted(context, LBL_DESCRIPTION)!)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: widget.qty,
                onChanged: (value) {
                  SparePart part = widget.allParts!.firstWhere((element) =>
                      element.partNo!.toUpperCase() ==
                      widget.partNo.text.toUpperCase());
                  if (part != null) {
                    setState(() {
                      widget.desc.text = part.desc!;
                    });
                  }
                },
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
