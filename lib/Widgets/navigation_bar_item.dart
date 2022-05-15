// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_value.dart';

import '../Helpers/layout_constants.dart';

class NavigationBarItem extends StatefulWidget {
  String text;
  void Function() onTap;
  NavigationBarItem({required this.text, Key? key, required this.onTap})
      : super(key: key);

  @override
  State<NavigationBarItem> createState() => _NavigationBarItemState();
}

class _NavigationBarItemState extends State<NavigationBarItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: InkWell(
        splashColor: Colors.white60,
        onTap: widget.onTap,
        child: Container(
          height: 60.0,
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(widget.text,
              style: TextStyle(
                color: ICON_TEX_COLOR,
                fontSize:
                    ResponsiveValue(context, defaultValue: 15.0, valueWhen: [
                  const Condition.smallerThan(name: MOBILE, value: 10.0),
                  const Condition.largerThan(name: DESKTOP, value: 25.0)
                ]).value,
              )),
        ),
      ),
    );
  }
}
