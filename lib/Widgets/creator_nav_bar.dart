import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:flutter/material.dart';

class CreatorDrawerWidget extends StatefulWidget {
  const CreatorDrawerWidget({Key? key}) : super(key: key);

  @override
  _CreatorDrawerWidgetState createState() => _CreatorDrawerWidgetState();
}

class _CreatorDrawerWidgetState extends State<CreatorDrawerWidget> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: Image.asset(
              IMG_LOGO,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            height: 3,
            color: ICONS_COLOR,
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: ICONS_COLOR,
            ),
            title: Text(getTranselted(context, HOME_PAGE_TITLE)!),
            onTap: () {},
          ),
          // const Divider(),
          ListTile(
            leading: const Icon(
              Icons.task,
              color: ICONS_COLOR,
            ),
            title: Text(getTranselted(context, TODAY_TICKETS)!),
            onTap: () {},
          ),
          // const Divider(),
          ListTile(
            leading: const Icon(
              Icons.people,
              color: ICONS_COLOR,
            ),
            title: Text(getTranselted(context, CUSTOMER_MGMT)!),
            onTap: () {},
          ),
          // const Divider(),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: ICONS_COLOR,
            ),
            title: Text(getTranselted(context, SETTINGS)!),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
