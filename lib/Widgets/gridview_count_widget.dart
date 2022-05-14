// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class GridViewCountWidget extends StatelessWidget {
  List<Widget> widgets;
  GridViewCountWidget({Key? key, required this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.only(top: 20, right: 5, left: 5),
      shrinkWrap: true,
      crossAxisCount:
          ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) ? 2 : 6,
      mainAxisSpacing: 9,
      crossAxisSpacing: 5,
      children: widgets,
    );
  }
}
