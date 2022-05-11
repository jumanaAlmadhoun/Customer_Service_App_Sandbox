import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: import_of_legacy_library_into_null_safe
import '../../../main.dart';
import '../../Localization/localization_constants.dart';

class TechHomePage extends StatefulWidget {
  const TechHomePage({Key? key}) : super(key: key);

  @override
  _TechHomePageState createState() => _TechHomePageState();
}

class _TechHomePageState extends State<TechHomePage> with RouteAware {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // fbm.subscribeToTopic(userName).then((value) {});
  }

  @override
  void didChangeDependencies() {
    // ignore: todo
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  // ignore: unnecessary_overrides
  void didPush() {
    // Provider.of<SparePartsProvider>(context, listen: false).fetchSpareParts();
    super.didPush();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffE9EBE9),
      appBar: AppBar(
        backgroundColor: const Color(0xffDFE0DF),
        title: Text(
          getTranselted(context, HOME_PAGE_TITLE)!,
          style: const TextStyle(color: Color(0xff512100)),
        ),
        leading: IconButton(
          icon: Image.asset(
            'Assets/Images/rfa_logo.png',
          ),
          onPressed: () {},
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('COFFEbEANS.png'), fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: [
            //  Image.asset(IMG_LOGO),
            const SizedBox(
              height: 50,
            ),
            /* ButtonWidget(
              text: getTranselted(context, VIEW_OPEN_TICKETS)!,
              onTap: () {
                Navigator.pushNamed(context, techOpenTicketRoute);
              },
            ),
            const SizedBox(
              height: 30,
            ),
            ButtonWidget(
              text: getTranselted(context, VIEW_CLOSED_TICKETS)!,
              onTap: () async {
                // Navigator.pushNamed(context, TechClosedTicketsScreen.id);
              },
            ),
            const SizedBox(
              height: 30,
            ),
            ButtonWidget(
              text: getTranselted(context, LOGOUT)!,
              onTap: () async {
                try {
                  var pref = await SharedPreferences.getInstance();
                  pref.remove(LoginHandeler.PHONE_NUMBER);
                  pref.remove(LoginHandeler.PASSWORD);
                  pref.remove(LoginHandeler.NAME);
                  pref.remove(LoginHandeler.ROLE);
                  Navigator.pushNamedAndRemoveUntil(context, loginRoute,
                      (route) {
                    ModalRoute.withName(loginRoute);
                    return false;
                  });
                } catch (ex) {
                  throw Exception(ex);
                }
              },
            ),*/
            InkWell(
              onTap: () {},
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: size.height * 0.1,
                  width: size.width * 0.8,
                  padding: const EdgeInsets.all(0.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.white,
                    border: Border.all(color: Color(0xffD68D0A), width: 3.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 8.0,
                          offset: Offset(0.0, 10.0))
                    ],
                  ),
                  child: Text(
                    getTranselted(context, VIEW_OPEN_TICKETS)!,
                    style: const TextStyle(
                        fontFamily: 'Signika Negative',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff512100)),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
