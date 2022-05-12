import 'package:flutter/material.dart';

import '../Helpers/layout_constants.dart';

class WebAppBar extends StatelessWidget {
  List<Widget> navItem;
  WebAppBar({Key? key, required this.navItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: APP_BAR_COLOR,
        height: size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              IMG_LOGO,
              height: size.height * 0.08,
            ),
            Row(children: navItem),
          ],
        ));
  }
}
