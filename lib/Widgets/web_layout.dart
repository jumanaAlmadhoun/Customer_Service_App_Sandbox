// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../Helpers/layout_constants.dart';

class WebLayout extends StatelessWidget {
  List<Widget> navItem;
  Widget widget;
  WebLayout({Key? key, required this.navItem, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
        ? Container(child: widget)
        : SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    color: APP_BAR_COLOR,
                    height: size.height * 0.12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'Assets/Images/rfa_logo.png',
                          height: size.height * 0.1,
                        ),
                        Row(children: navItem),
                      ],
                    )),
                Container(
                  height: size.height,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            WEB_BACKGROUND,
                          ),
                          fit: BoxFit.fill)),
                  child: Center(child: widget),
                )
              ],
            ),
          );
  }
}
