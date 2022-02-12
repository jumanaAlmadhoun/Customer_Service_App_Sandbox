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
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              IMG_LOGO,
              fit: BoxFit.contain,
            ),
          ),
          const Divider(
            height: 5,
            color: APP_BAR_COLOR,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(getTranselted(context, HOME_PAGE_TITLE)!),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.task),
            title: Text(getTranselted(context, TODAY_TICKETS)!),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text(getTranselted(context, CUSTOMER_MGMT)!),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(getTranselted(context, SETTINGS)!),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
