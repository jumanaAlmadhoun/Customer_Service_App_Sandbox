// ignore_for_file: use_key_in_widget_constructors, import_of_legacy_library_into_null_safe, unused_element

import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:customer_service_app/Services/login_provider.dart';
import 'package:customer_service_app/Widgets/language_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helpers/layout_constants.dart';
import '../../main.dart';
import 'mobile_logIn_page.dart';
import 'web_logIn_page.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with RouteAware {
  bool _isLoading = false;
  bool _obscureText = true;

  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString(LoginHandeler.PHONE_NUMBER) != null) {
      userName = prefs.getString(LoginHandeler.NAME).toString();
      role = prefs.getString(LoginHandeler.ROLE).toString();
      Provider.of<LoginHandeler>(context, listen: false)
          .directUser(context, role.toString());
    }
    super.didPush();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < mobileWidth) {
          return Scaffold(
              appBar: AppBar(
                title: Text(getTranselted(context, LOGIN_TXT)!),
                centerTitle: true,
                actions: [LanguageWidget()],
              ),
              body: _isLoading
                  ? const Center(
                      child: SpinKitPumpingHeart(
                      color: APP_BAR_COLOR,
                    ))
                  : MobileLogInPage(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });
                        Provider.of<LoginHandeler>(context, listen: false)
                            .loginUser(context, phoneNumber.text.trim(),
                                password.text.trim())
                            .then((value) {
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      },
                      password: password,
                      phoneNumber: phoneNumber,
                    ));
        } else {
          return Scaffold(
            body: _isLoading
                ? const Center(
                    child: SpinKitPumpingHeart(
                    color: APP_BAR_COLOR,
                  ))
                : WebLogInPage(
                    onTap: () {
                      setState(() {
                        _isLoading = true;
                      });
                      Provider.of<LoginHandeler>(context, listen: false)
                          .loginUser(context, phoneNumber.text.trim(),
                              password.text.trim())
                          .then((value) {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    },
                    password: password,
                    phoneNumber: phoneNumber,
                  ),
          );
        }
      },
    );
  }
}
