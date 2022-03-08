import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Models/spare_parts.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class SparePartWidget extends StatefulWidget {
  SparePartWidget({this.allParts, this.isfree = false});
  TextEditingController partNo = TextEditingController();
  TextEditingController qty = TextEditingController();
  List<SparePart>? allParts;
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
                    validator: (value) {
                      if (widget.allParts!.firstWhere((element) =>
                                  element.partNo!.toUpperCase() ==
                                  value!.toUpperCase()) ==
                              null ||
                          value!.isEmpty) {
                        return 'رقم القطعة خطأ';
                      } else {
                        return null;
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
                  controller: widget.qty,
                  onChanged: (value) {
                    SparePart part = widget.allParts!.firstWhere((element) =>
                        element.partNo!.toUpperCase() ==
                        widget.partNo.text.toUpperCase());
                    if (part != null && value.isNotEmpty) {
                      if (widget.isfree == false) {
                        setState(() {
                          widget.amount = part.price! * double.parse(value);
                        });
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
