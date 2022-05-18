// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../Helpers/layout_constants.dart';

class GridViewBuilder extends StatelessWidget {
  List list;
  GridViewBuilder({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? 1
              : (ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
                      ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                  ? 2
                  : 4,
          childAspectRatio: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? 2.5
              : (ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
                      ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                  ? 2
                  : 1.5),
      itemCount: list.length,
      itemBuilder: (context, i) {
        return Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: ICONS_COLOR, width: 3.0),
                  borderRadius: BorderRadius.circular(15),
                  color: list[i].status == 'With Customer'
                      ? NOT_CONTACTED_COLOR
                      : CONTACTED_COLOR),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(list[i].status!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    list[i].machineModel!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(list[i].serialNumber!,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(list[i].location!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ));
      },
    );
  }
}
