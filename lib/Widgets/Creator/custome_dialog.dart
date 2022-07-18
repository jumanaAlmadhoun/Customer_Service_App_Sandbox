import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog(
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
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            TextFormField(
              decoration:
                  const InputDecoration(label: Text('Sales Order Number')),
              controller: widget.controller,
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
                    if (widget.controller!.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Enter Sales Order Number'),
                          backgroundColor: ERROR_COLOR,
                        ),
                      );
                    } else {
                      Navigator.of(context).pop();
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
