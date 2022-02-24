import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class TechHomePage extends StatefulWidget {
  const TechHomePage({Key? key}) : super(key: key);

  @override
  _TechHomePageState createState() => _TechHomePageState();
}

class _TechHomePageState extends State<TechHomePage> with RouteAware {
  void initState() {
    // TODO: implement initState
    super.initState();
    // fbm.subscribeToTopic(userName).then((value) {});
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    // Provider.of<SparePartsProvider>(context, listen: false).fetchSpareParts();
    super.didPush();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          Image.asset(IMG_LOGO),
          const SizedBox(
            height: 50,
          ),
          ButtonWidget(
            text: 'عرض التذاكر المفتوحة',
            onTap: () {
              Navigator.pushNamed(context, techOpenTicketRoute);
            },
          ),
          const SizedBox(
            height: 30,
          ),
          ButtonWidget(
            text: 'عرض التذاكر المغلقة',
            onTap: () async {
              // Navigator.pushNamed(context, TechClosedTicketsScreen.id);
            },
          ),
          const SizedBox(
            height: 30,
          ),
          ButtonWidget(
            text: 'تسجيل خروج',
            onTap: () async {
              try {
                var pref = await SharedPreferences.getInstance();
                pref.remove(LoginHandeler.PHONE_NUMBER);
                pref.remove(LoginHandeler.PASSWORD);
                pref.remove(LoginHandeler.NAME);
                pref.remove(LoginHandeler.ROLE);
                Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) {
                  ModalRoute.withName(loginRoute);
                  return false;
                });
              } catch (ex) {
                print(ex);
              }
            },
          ),
        ]),
      ),
    );
  }
}
