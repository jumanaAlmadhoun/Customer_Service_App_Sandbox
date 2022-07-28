import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:customer_service_app/Util/formatters.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class SparePartWidget extends StatefulWidget {
  SparePartWidget(
      {this.allParts,
      this.validatePartNum,
      this.validatePartQuantity,
      this.isfree = false,
      this.partNo,
      this.qty,
      this.isFreePart = false,
      this.amount = 0});
  TextEditingController? partNo;
  TextEditingController? qty;
  TextEditingController desc = TextEditingController();
  List<SparePart>? allParts;
  String? Function(String?)? validatePartNum;
  String? Function(String?)? validatePartQuantity;
  SparePart? selectedPart;
  bool? isFreePart;
  double amount = 0;
  bool? isfree;
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
            color: Colors.white),
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
                    onTap: (value) {
                      widget.selectedPart = widget.allParts!.firstWhere(
                          (element) =>
                              element.partNo!.toUpperCase() ==
                              value.searchKey.toUpperCase());
                      if (widget.selectedPart != null) {
                        setState(() {
                          widget.desc.text = widget.selectedPart!.desc!;
                        });
                      }
                    },
                    suggestions: widget.allParts!
                        .map((e) => SearchFieldListItem(e.partNo.toString()))
                        .toList()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  validator: widget.validatePartQuantity,
                  keyboardType: TextInputType.number,
                  controller: widget.qty,
                  inputFormatters: [OneDigitFormatter()],
                  onChanged: (value) {
                    widget.selectedPart = widget.allParts!.firstWhere(
                        (element) =>
                            element.partNo!.toUpperCase() ==
                            widget.partNo!.text.toUpperCase());
                    if (widget.selectedPart != null && value.isNotEmpty) {
                      if (widget.isfree == false) {
                        widget.isFreePart = false;
                        setState(() {
                          widget.amount =
                              widget.selectedPart!.price! * double.parse(value);
                        });
                      } else {
                        widget.isFreePart = true;
                      }
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
