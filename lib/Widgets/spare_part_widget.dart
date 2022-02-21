import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class SparePartWidget extends StatefulWidget {
  SparePartWidget(
      {this.allParts, this.validatePartNum, this.validatePartQuantity});
  TextEditingController partNo = TextEditingController();
  TextEditingController qty = TextEditingController();
  List<SparePart>? allParts;
  String? Function(String?)? validatePartNum;
  String? Function(String?)? validatePartQuantity;
  double amount = 0;
  @override
  _SparePartWidgetState createState() => _SparePartWidgetState();
}

class _SparePartWidgetState extends State<SparePartWidget> {
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
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SearchField(
                    maxSuggestionsInViewPort: 5,
                    searchInputDecoration: const InputDecoration(
                      label: Text('رقم القطعة'),
                    ),
                    controller: widget.partNo,
                    validator: widget.validatePartNum,
                    suggestions: widget.allParts!
                        .map((e) => e.partNo.toString())
                        .toList()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  validator: widget.validatePartQuantity,
                  controller: widget.qty,
                  onChanged: (value) {
                    SparePart part = widget.allParts!.firstWhere((element) =>
                        element.partNo!.toUpperCase() ==
                        widget.partNo.text.toUpperCase());
                    if (part != null && value.isNotEmpty) {
                      setState(() {
                        widget.amount = part.price! * double.parse(value);
                      });
                    }
                  },
                  decoration: const InputDecoration(label: Text('العدد')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
