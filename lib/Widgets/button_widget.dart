import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final onTap;
  ButtonWidget({
    this.text = ' ',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: InkWell(
        onTap: onTap,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            height: 50.0,
            padding: EdgeInsets.all(0.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: APP_BAR_COLOR,
            ),
            child: Text(
              text,
              style: const TextStyle(
                  fontFamily: 'Signika Negative',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: APP_BAR_TEXT_COLOR),
            ),
          ),
        ),
      ),
    );
  }
}
