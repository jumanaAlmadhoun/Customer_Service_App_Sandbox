// ignore_for_file: unused_import, unnecessary_overrides

import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:customer_service_app/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: import_of_legacy_library_into_null_safe
import '../../../main.dart';
import '../../Localization/localization_constants.dart';
import '../../Widgets/appBar.dart';
import '../../Widgets/logout_widget.dart';
import '../../Widgets/web_layout.dart';

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
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    // Provider.of<SparePartsProvider>(context, listen: false).fetchSpareParts();
    print('Pushed');
    super.didPush();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: BACK_GROUND_COLOR,
      appBar: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? CustomeAppBar(
              title: Text(
              getTranselted(context, HOME_PAGE_TITLE)!,
              style: APPBAR_TEXT_STYLE,
            ))
          : null,
      body: WebLayout(
          navItem: [
            InkWell(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, techHomeRoute, (route) {
                ModalRoute.withName(techHomeRoute);
                return false;
              }),
              child: Text(
                getTranselted(context, HOME_PAGE_TITLE)!,
                style: APPBAR_TEXT_STYLE,
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            const LogoutWidget(),
          ],
          widget: SingleChildScrollView(
            child: ResponsiveRowColumn(
              rowMainAxisAlignment: MainAxisAlignment.center,
              rowPadding: const EdgeInsets.all(30),
              columnPadding: const EdgeInsets.all(30),
              columnSpacing: 20,
              rowSpacing: 20,
              layout: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              children: [
                ResponsiveRowColumnItem(
                  child: ResponsiveVisibility(
                      hiddenWhen: const [Condition.largerThan(name: TABLET)],
                      child: Image.asset(IMG_LOGO)),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: ButtonWidget(
                    text: 'عرض التذاكر المفتوحة',
                    height: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                        ? size.height * 0.13
                        : size.height * 0.20,
                    width: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                        ? size.width * 0.70
                        : size.width * 0.30,
                    onTap: () {
                      Navigator.pushNamed(context, techOpenTicketRoute);
                    },
                  ),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: ButtonWidget(
                    height: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                        ? size.height * 0.13
                        : size.height * 0.20,
                    width: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                        ? size.width * 0.70
                        : size.width * 0.30,
                    text: 'عرض التذاكر المغلقة',
                    onTap: () async {
                      Navigator.pushNamed(context, techCloseTicketsRoute);
                    },
                  ),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: ResponsiveVisibility(
                    hiddenWhen: const [Condition.largerThan(name: TABLET)],
                    child: ButtonWidget(
                      text: 'تسجيل خروج',
                      height:
                          ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                              ? size.height * 0.13
                              : size.height * 0.20,
                      width:
                          ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                              ? size.width * 0.70
                              : size.width * 0.30,
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
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
