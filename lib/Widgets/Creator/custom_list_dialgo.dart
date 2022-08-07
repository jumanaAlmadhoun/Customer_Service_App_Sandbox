import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomListDialog extends StatefulWidget {
  CustomListDialog(
      {this.controller,
      this.msg,
      this.hint,
      this.onTap,
      this.items,
      this.function});
  TextEditingController? controller;
  final String? msg;
  final String? hint;
  List<String>? items;
  String? value;
  final Function? function;
  final onTap;

  @override
  _CustomListDialogState createState() => _CustomListDialogState();
}

class _CustomListDialogState extends State<CustomListDialog> {
  bool _isLoading = false;
  TextEditingController? classController;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Dialog(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 250.0,
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.msg!,
              style: const TextStyle(
                fontFamily: 'Signika Negative',
                fontSize: 21.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            DropdownButton(
              isExpanded: true,
              hint: Text(getTranselted(context, LBL_CHOOSE_REASON)!),
              items: widget.items!
                  .map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ))
                  .toList(),
              value: widget.value,
              onChanged: (select) {
                setState(() {
                  widget.value = select.toString();
                });
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: (width / 3.5),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      getTranselted(context, BTN_CANCEL)!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (widget.value != null) {
                      Navigator.of(context).pop(true);
                    } else {
                      String text = getTranselted(context, LBL_CHOOSE_REASON)!;
                      final snackBar = SnackBar(
                        content: Text(text),
                        backgroundColor: ERROR_COLOR,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
                    width: (width / 3.5),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: SpinKitChasingDots(
                              size: 20,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            getTranselted(context, BTN_SEND)!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
