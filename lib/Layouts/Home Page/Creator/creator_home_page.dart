import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:flutter/material.dart';

class CreatorHomePage extends StatefulWidget {
  const CreatorHomePage({Key? key}) : super(key: key);

  @override
  _CreatorHomePageState createState() => _CreatorHomePageState();
}

class _CreatorHomePageState extends State<CreatorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranselted(context, HOME_PAGE_TITLE)!),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(getTranselted(context, TIC_SITE_VISIT)!),
            leading: const Icon(Icons.sticky_note_2),
            shape: Border.all(color: Colors.black),
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(getTranselted(context, HOME_PAGE_TITLE)!),
      centerTitle: true,
    );
  }
}
