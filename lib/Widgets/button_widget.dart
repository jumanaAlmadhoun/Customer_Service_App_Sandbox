// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../Helpers/layout_constants.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final onTap;
  double height;
  double width;
  ButtonWidget(
      {Key? key,
      this.text = ' ',
      required this.onTap,
      this.height = 60,
      this.width = 400})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(0.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90.0),
              color: Colors.white,
              border: Border.all(color: ICONS_COLOR, width: 3.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 90, 90, 90),
                  blurRadius: 30.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                  fontFamily: 'Signika Negative',
                  fontSize:
                      ResponsiveValue(context, defaultValue: 20.0, valueWhen: [
                    const Condition.smallerThan(name: MOBILE, value: 10.0),
                    const Condition.largerThan(name: TABLET, value: 25.0)
                  ]).value,
                  fontWeight: FontWeight.w700,
                  color: ICON_TEX_COLOR),
            ),
          ),
        ),
      ),
    );
  }
}
