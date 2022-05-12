// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../Helpers/layout_constants.dart';

class CustomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(55);
  // ignore: prefer_typing_uninitialized_variables
  Widget title;
  Widget? leading;
  List<Widget>? action;
  CustomeAppBar({Key? key, required this.title, this.leading, this.action})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: APP_BAR_COLOR,
      title: title,
      leading: leading,
      actions: action,
    );
  }
}
